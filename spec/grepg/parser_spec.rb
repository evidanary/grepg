require 'json'
require 'yaml'
require_relative '../../lib/grepg.rb'

describe GrepPage::Parser do
  describe '.initialize' do
    context "expected behavior" do
      it "returns a set of cheats when username and topic are given" do
        parser = GrepPage::Parser.new('-u kdavis -t css'.split(' '))
        output = capture_stdout { parser.run! }
        expect(output).to match(/colors/)
      end

      it "returns a set of cheats when username, topic and search term are given" do
        parser = GrepPage::Parser.new('-u kdavis -t css -s colors'.split(' '))
        output = capture_stdout { parser.run! }
        expect(output).to match(/colors/)
      end

      # Test if we are seeing colors in the output
      # This is blue - "\e[0;34;49mThis is blue\e[0m"
      it "colorizes output of the result" do
        parser = GrepPage::Parser.new('-u kdavis -t css -c'.split(' '))
        output = capture_stdout { parser.run! }
        expect(output.inspect).to include("\\e[0;34;49m")
      end

      # Test if defaut file gets read
      it "reads username from the defaults file" do
        expect(File).to receive(:exist?).and_return(true)
        expect(IO).to receive(:read).with(ENV['HOME'] + '/.grepg.yml').and_return({
          "user" => "kdavis"
        }.to_yaml)
        parser = GrepPage::Parser.new('-t css'.split(' '))
        expect(parser.instance_variable_get(:@opts)[:user]).to eq('kdavis')
      end

      # Test if we get an error when no user is specified. We should tell the user
      # a sample username they can use if they want to try the client out without
      # creating an account
      it "errors when no user is specified" do
        expect(File).to receive(:exist?).and_return(false)
        expect do
          output = GrepPage::Parser.new('-t css'.split(' '))
          expect(output).to match(/Missing --user parameter.*--user.*"/)
        end.to raise_error(SystemExit)
      end

      it "shows all topics when no topic filter is specified" do
        parser = GrepPage::Parser.new('-u kdavis'.split(' '))
        output = capture_stdout { parser.run! }
        expect(output).to match(/UNIX/)
      end
    end
  end

  describe '#default_file_name' do
    it('returns nil if ~/.grepg.yml doesnt exist') do
      expect(File).to receive(:exist?).and_return(false)
      expect(GrepPage::Parser.default_file_name).to be(nil)
    end

    it('returns filename if ~/.grepg.yml exists') do
      expect(File).to receive(:exist?).and_return(true)
      expect(GrepPage::Parser.default_file_name).to eq(ENV['HOME'] + '/.grepg.yml')
    end
  end

  describe '#get_default_config' do
    it('returns empty hash if ~/.grepg.yml doesnt exist') do
      expect(File).to receive(:exist?).and_return(false)
      expect(GrepPage::Parser.get_default_config).to eq({})
    end

    it('returns parses YML if ~/.grepg.yml exists') do
      default_contents = {
        "user" => "test"
      }
      expect(File).to receive(:exist?).and_return(true)
      expect(IO).to receive(:read).and_return(default_contents.to_yaml)
      expect(GrepPage::Parser.get_default_config).to eq(default_contents)
    end
  end
end


