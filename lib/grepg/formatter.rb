require 'colorize'
module GrepPage
  class Formatter
    # Displays an array of cheats
    # TODO: Highlight search term
    DESCRIPTION_COLOR= :green
    COMMAND_COLOR= :blue
    def self.cheat_rows(cheats, search_term, colorize)
      cheats.map do |cheat|
        description = cheat[:description]
        command = cheat[:command]
        if colorize
          description = description.colorize(DESCRIPTION_COLOR)
          command = command.colorize(COMMAND_COLOR)
        end
        puts description
        puts command
        puts
      end
    end
  end
end
