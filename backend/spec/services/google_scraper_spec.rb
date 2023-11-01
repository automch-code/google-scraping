require 'rails_helper'

RSpec.describe GoogleScraper, type: :service do
  include ActiveJob::TestHelper
  
  let!(:user_1)         { FactoryBot.create(:user) }


  describe '#call' do
    it 'create keyword from word in csv' do
      result = GoogleScraper.call(['cat'], user_1.id)

      expect(result[0]).to be_present
    end
  end
end