require 'trollop'

# This class parses commandline arguments
module GrepPage
  class Parser
    def initialize(args)
      @user = args.shift
      @topic = args.shift
      @opts = Trollop::options(args) do
        opt :search,
          "text to search",
          :type => :string,
          :required => false,
          :short => "-s"
        banner <<-EOS
Test is an awesome program that does something very, very important.

Usage:
  test [options] <filenames>+
  where [options] are:
EOS
      end
      @search_term = @opts[:search]
    end

    def run!
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
