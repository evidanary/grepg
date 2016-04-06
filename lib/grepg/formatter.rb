require 'colorize'
module GrepPage
  class Formatter
    # Displays an array of cheats
    def self.cheat_rows(cheats, search_term)
      cheats.map do |cheat|
        puts cheat[:description].colorize(:green)
        puts cheat[:command].colorize(:blue).on_black
        puts
      end
    end
  end
end
