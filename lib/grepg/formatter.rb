require 'colorize'
module GrepPage
  class Formatter
    # Displays an array of cheats
    # TODO: Highlight search term
    def self.cheat_rows(cheats, search_term, colorize)
      cheats.map do |cheat|
        description = cheat[:description]
        command = cheat[:command]
        if colorize
          description = description.colorize(:green)
          command = command.colorize(:blue)
        end
        puts description
        puts command
        puts
      end
    end
  end
end
