require 'rest-client'

module GrepPage
  module API
    BASE_URL = 'https://www.greppage.com/api'
    ACCESS_TOKEN = 'Bearer eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiIsImFsZyI6IkhTMjU2IiwidHlwIjoiSldUIn0.eyJpZCI6MjAwMDAwMDAwMCwiZW1haWwiOiJndWVzdEBndWVzdC5jb20iLCJuYW1lIjoiZ3Vlc3QiLCJleHAiOjE1MTExMzY4MzB9.gWohR7LLtROgjSl5SxbEaGRBveZQEv7Uj2rzmgYrbys'
    def self.get(uri, access_token = ACCESS_TOKEN)
      RestClient.get uri, {:accept => :json, :authorization => access_token}
    end

    def self.sheets(user_name)
      response = get(sheets_uri(user_name))
      raise RunTimeException if response.code != 200

      JSON.parse(response.to_str, symbolize_names: true)
    end

    def self.cheats(user_name, sheet_id)
      response = get(cheats_uri(user_name, sheet_id))
      raise Exception if response.code != 200

      JSON.parse(response.to_str, symbolize_names: true)
    end

    def self.sheets_uri(user_name)
      [BASE_URL, 'users', user_name, 'sheets_with_stats'].join('/')
    end

    def self.cheats_uri(user_name, sheet_id)
      [BASE_URL, 'users', user_name, 'sheets', sheet_id, 'cheats'].join('/')
    end
  end
end

