require 'json'
require_relative '../../lib/grepg.rb'

describe GrepPage::API do
  let(:user_name) {TEST_USER}
  let(:sheet_id) {TEST_SHEET_ID}

  context "Sheet Fetching" do
    let(:api) {GrepPage::API}
    it "checks for a JSON array" do
      sheets = api.sheets(user_name)
      expect(sheets.class).to eq(Array)
    end

    it "checks for name and id field in each sheet" do
      sheets = api.sheets(user_name)
      expect(sheets.first[:name]).to be_truthy
      expect(sheets.first[:id]).to be_truthy
    end
  end

  context "Cheats Fetching" do
    let(:api) {GrepPage::API}
    it "checks for a JSON array" do
      sheets = api.cheats(user_name, sheet_id)
      expect(sheets.class).to eq(Array)
    end

    it "checks for name and id field in each cheat" do
      sheets = api.cheats(user_name, sheet_id)
      expect(sheets.first[:command]).to be_truthy
      expect(sheets.first[:description]).to be_truthy
    end
  end
end


