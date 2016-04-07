require 'webmock/rspec'
# This should almost always remain true. We should test locally
TEST_LOCALLY = true
# The user whose cheats we will access
TEST_USER = 'kdavis'
# The sheet_id of the test user
TEST_SHEET_ID = '68'
# Disable outgoing network connections
TEST_LOCALLY ? WebMock.disable_net_connect! : WebMock::allow_net_connect!

# TODO: This is probably not a good place to put the stubbing logic
RSpec.configure do |config|
  config.before(:each) do
    if(TEST_LOCALLY)
      configure_sheets_endpoint
      configure_cheats_endpoint
    end
  end

  def configure_sheets_endpoint
    access_token = GrepPage::API::ACCESS_TOKEN

    # Assuming that these are the responses returned by the API
    sheets_body = %Q[
     [{"id":68,"name":"CSS","user_id":18,"created_at":"2016-03-16T11:46:27-07:00","updated_at":"2016-03-16T11:46:27-07:00"},{"id":69,"name":"ES6","user_id":18,"created_at":"2016-03-16T11:49:30-07:00","updated_at":"2016-03-16T11:49:30-07:00"},{"id":70,"name":"UNIX","user_id":18,"created_at":"2016-03-16T11:55:25-07:00","updated_at":"2016-03-16T11:55:25-07:00"},{"id":71,"name":"GIT","user_id":18,"created_at":"2016-03-16T12:25:25-07:00","updated_at":"2016-03-16T12:25:25-07:00"}]
    ].strip
    stub_request(:get, "https://www.greppage.com/api/users/#{TEST_USER}/sheets_with_stats").
      with(:headers => {"Authorization" => GrepPage::API::ACCESS_TOKEN}).
      to_return(status: 200, body: sheets_body, headers: {})
  end

  def configure_cheats_endpoint
    # Assuming that these are the responses returned by the API
    cheats_body = %Q[
      [{"id":718,"description":"color palette for web safe colors","command":"http://0xrgb.com/#flat","sheet_id":1,"created_at":"2015-12-19T12:55:19-08:00","updated_at":"2015-12-19T12:55:19-08:00"},{"id":728,"description":"Bootstrap text formatting styles","command":"http://www.w3schools.com/bootstrap/bootstrap_ref_css_text.asp","sheet_id":1,"created_at":"2015-12-29T21:16:34-08:00","updated_at":"2015-12-29T21:16:34-08:00"}]
    ].strip
    stub_request(:get, "https://www.greppage.com/api/users/#{TEST_USER}/sheets/#{TEST_SHEET_ID}/cheats").
      with(:headers => {"Authorization" => GrepPage::API::ACCESS_TOKEN}).
      to_return(status: 200, body: cheats_body, headers: {})
  end
end

def capture_stdout(&block)
  original_stdout = $stdout
  $stdout = fake = StringIO.new
  begin
    yield
  ensure
    $stdout = original_stdout
  end
  fake.string
end
