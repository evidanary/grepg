require_relative '../../lib/grepg.rb'

describe GrepPage::Parser do
  describe '.process_args' do
    let(:parser) {  GrepPage::Parser.new(['kdavis', 'css', '-s', 'style']) }
    it 'returns a chunk of text' do
      expect(parser.run!).to eq(['kdavis', 'css', 'style'])
    end
  end
end

