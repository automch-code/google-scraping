require 'rails_helper'

RSpec.describe ImportKeywordsJob, type: :job do
  include ActiveJob::TestHelper

  describe 'perform' do
    let!(:user_1)         { FactoryBot.create(:user) }
    let!(:import)         { FactoryBot.create(:import_history ,user_id: user_1.id) }
    subject(:job)         { described_class.perform_later(import, user_1) }

    it 'queues the job' do
      expect { job }
        .to change(ActiveJob::Base.queue_adapter.enqueued_jobs, :size).by(1)
    end

    it 'executes perform' do
      expect(GoogleScraper).to receive(:call).with(['cat'], user_1.id)
      perform_enqueued_jobs { job }
    end

  end

  after do
    clear_enqueued_jobs
    clear_performed_jobs
  end
end