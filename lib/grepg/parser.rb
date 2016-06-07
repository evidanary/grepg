require 'trollop'
require 'rest-client'
require 'yaml'

# This class parses commandline arguments
module GrepPage
  class Parser
    def initialize(args)
      default_config = self.class.get_default_config
      parser = Trollop::Parser.new do
        opt :user,
          "username",
          :type => :string,
          :default => default_config['user'],
          :short => "-u"
        opt :topic,
          "topic",
          :type => :string,
          :required => false,
          :short => "-t"
        opt :search,
          "text to search",
          :type => :string,
          :required => false,
          :short => "-s"
        opt :colorize,
          "colorize output",
          :type => :boolean,
          :default => default_config['colorize'],
          :short => "-c"
        version "grepg version #{GrepPage::VERSION}"
        banner <<-EOS

Usage:
  grepg -u user_name [-t topic_name -s search_term]

Examples:
  grepg -u evidanary -t css
  greppg -u evidanary -t css -s color

Defaults:
  To set defaults, create a file in ~/.grepg.yml with
  user: test
  colorize: true
        EOS
      end

      @opts = Trollop::with_standard_exception_handling parser do
        opts = parser.parse args
        # User is a required field, manually handling validation because
        # we fallback on defaults from the file
        raise Trollop::CommandlineError,
          "Missing --user parameter. e.g. --user evidanary" unless opts[:user]
        opts
      end

      @user = @opts[:user]
      @topic = @opts[:topic]
      @search_term = @opts[:search]
      @colorize = @opts[:colorize]
    end

    def self.get_default_config
      file = self.default_file_name
      file ? YAML.load(IO.read(file)) : {}
    end

    def self.default_file_name
      file = ENV['HOME'] + '/.grepg.yml'
      File.exist?(file) ? file : nil
    end

    def get_all_topics(user)
      GrepPage::API.sheets(user)
    end

    def filter_topics(topics, topic_name = '')
      sheet = topics.find{|topic| topic[:name].downcase == topic_name.downcase}
      sheet = topics.find{|topic| topic[:name].downcase[topic_name.downcase]} unless sheet
      sheet
    end

    def get_cheats(user, sheet_id)
      GrepPage::API.cheats(user, sheet_id)
    end

    def filter_cheats(cheats, search_term)
      cheats.select do |cheat|
        (cheat[:description].downcase[search_term.downcase] ||
         cheat[:command].downcase[search_term.downcase]) != nil
      end
    end

    def process_args(user, topic, search_term, colorize)
      headers = ["User: #{user}"]
      headers << "Topic: #{topic}" if topic
      headers << "Search-Term: #{search_term}" if search_term
      puts headers.join(", ")

      begin
        topics = get_all_topics(user)
      rescue RestClient::ResourceNotFound
        raise GrepPage::NotFoundError, "Unable to find user"
      end

      unless topic
        # No topic specified so show all topics
        puts "Available Topics => "
        puts topics.map{|t| t[:name]}
        return
      end

      topic = filter_topics(topics, topic)
      if topic.nil? || topic.empty?
        puts "Can't find that topic. Choose one of the following"
        puts topics.map{|t| t[:name]}
        raise GrepPage::NotFoundError, "Unable to find topic"
      end

      cheats = get_cheats(user, topic[:id])
      cheats = filter_cheats(cheats, search_term) if search_term

      GrepPage::Formatter.cheat_rows(cheats, search_term, colorize)
    end

    def run!
      begin
        process_args(@user, @topic, @search_term, @colorize)
      rescue GrepPage::NotFoundError => ex
        abort "Error: #{ex.message}"
      end
    end
  end
end
