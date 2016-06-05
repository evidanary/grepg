require 'colorize'
module GrepPage
  class Formatter
    # Displays an array of cheats
    # TODO: Highlight search term
    DESCRIPTION_COLOR = :green
    COMMAND_COLOR = :blue
    NONE_FOUND_COLOR = :green

    def self.cheat_rows(cheats, search_term, colorize)
      cheats.map do |cheat|
        description = cheat[:description]
        command = cheat[:command]
        print description, DESCRIPTION_COLOR, colorize
        print command, COMMAND_COLOR, colorize
        puts
      end
      print "None found", NONE_FOUND_COLOR, colorize if cheats.size == 0
    end

    def self.print(text, color, colorize)
      text = text.colorize(color) if colorize
      puts text
    end
  end
end
