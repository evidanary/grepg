require 'trollop'
require 'rest-client'

# This class parses commandline arguments
module GrepPage
  class Parser
    def initialize(args)
      parser = Trollop::Parser.new do
        opt :search,
          "text to search",
          :type => :string,
          :required => false,
          :short => "-s"
        opt :colorize,
          "colorize output",
          :type => :boolean,
          :short => "-c"
        opt :version,
          "version number of the gem",
          :type => :boolean,
          :short => "-v"
        banner <<-EOS

Usage:
  grepg user_name topic_name [-s search_term]

Examples:
  grepg kdavis css
  greppg kdavis css -s color
        EOS
      end

      @opts = Trollop::with_standard_exception_handling parser do
        raise Trollop::HelpNeeded if (args.size < 2 && !args.include?('--version')) # show help screen
        parser.parse args
      end

      leftovers = parser.leftovers
      @user = leftovers.shift
      @topic = leftovers.shift
      @search_term = @opts[:search]
      @colorize = @opts[:colorize]
      @version = @opts[:version]
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
      headers = ["User: #{user}", "Topic: #{topic}"]
      headers << "Search-Term: #{search_term}" if search_term
      puts headers.join(", ")

      begin
        topics = get_all_topics(user)
      rescue RestClient::ResourceNotFound
        puts "That username does not exist"
        exit 1
      end

      topic = filter_topics(topics, topic)
      if topic.nil? || topic.empty?
        puts "Can't find that topic. Choose one of the following"
        puts topics.map{|t| t[:name]}
        exit 1
      end

      cheats = get_cheats(user, topic[:id])
      cheats = filter_cheats(cheats, search_term) if search_term

      GrepPage::Formatter.cheat_rows(cheats, search_term, colorize)
    end

    def run!
      if(@version)
        puts "Version: #{GrepPage::Version}"
      else
        process_args(@user, @topic, @search_term, @colorize)
      end
    end
  end
end
