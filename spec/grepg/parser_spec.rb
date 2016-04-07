require 'json'
require_relative '../../lib/grepg.rb'

describe GrepPage::Parser do
  describe '.initialize' do
    context "expected behavior" do
      it "returns a set of cheats when username and topic are given" do
        parser = GrepPage::Parser.new(['kdavis', 'css'])
        output = capture_stdout { parser.run! }
        expect(output).to match(/colors/)
      end

      it "returns a set of cheats when username, topic and search term are given" do
        parser = GrepPage::Parser.new(['kdavis', 'css', '-s', 'colors'])
        output = capture_stdout { parser.run! }
        expect(output).to match(/colors/)
      end
    end
  end
end


