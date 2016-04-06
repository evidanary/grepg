require 'trollop'

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
        banner <<-EOS

Usage:
  grepg user_name topic_name [-s search_term]

Examples:
  grepg kdavis css
  greppg kdavis css -s color
        EOS
      end

      @opts = Trollop::with_standard_exception_handling parser do
        raise Trollop::HelpNeeded if args.empty? # show help screen
        parser.parse args
      end

      leftovers = parser.leftovers
      @user = leftovers.shift
      @topic = leftovers.shift
      @search_term = @opts[:search]
    end

    def run!
      headers = ["User: #{@user}", "Topic: #{@topic}"]
      headers << "Search-Term: #{@search_term}" if @search_term

      puts headers.join(", ")
      topics = GrepPage::API.sheets(@user)
      sheet = topics.select{|topic| topic[:name].downcase == @topic.downcase}.first
      sheet = topics.select{|topic| topic[:name].downcase[@topic.downcase]}.first unless sheet
      raise RunTimeException unless sheet

      sheet_id = sheet[:id]
      cheats = GrepPage::API.cheats(@user, sheet_id)
      raise RunTimeException unless cheats

      if(@search_term)
        cheats = cheats.select do |cheat|
          (cheat[:description].downcase[@search_term.downcase] ||
           cheat[:command].downcase[@search_term.downcase]) != nil
        end
      end

      GrepPage::Formatter.cheat_rows(cheats, @search_term)
    end
  end
end
