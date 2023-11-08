require 'rails_helper'

RSpec.describe GoogleScraper, type: :service do
  include ActiveJob::TestHelper
  
  let!(:user_1)         { FactoryBot.create(:user) }

  describe '#call' do
    it 'create keyword from word in csv' do
      response = File.read(fixture_file_path('stubs/cat.txt'))

      stub_request(:get, "https://www.google.com/search?hl=en&q=cat").
         with(
           headers: {
          'Accept'=>'*/*',
          'Accept-Encoding'=>'gzip;q=1.0,deflate;q=0.6,identity;q=0.3',
          'Accept-Language'=>'en-US',
          'User-Agent'=>'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/112.0.0.0 Safari/537.36'
           }).
         to_return(status: 200, body: response, headers: {})

      result = GoogleScraper.call(['cat'], user_1.id)

      expect(result[0]).to be_present
      expect(result[0][:word]).to eq('cat')
      expect(result[0][:results]).to eq(1460000000)
      expect(result[0][:rep_results]).to eq("1,460,000,000")
      expect(result[0][:speed]).to eq(0.42)
      expect(result[0][:links]).to eq(80)
      expect(result[0][:adwords]).to eq(0)
      expect(result[0][:rep_speed]).to eq("0.42")
      expect(result[0][:rep_links]).to eq("80")
      expect(result[0][:rep_adwords]).to eq("0")
    end
  end
end