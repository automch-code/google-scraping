require 'csv'

class ImportKeywordsJob < ApplicationJob
  queue_as :default
  sidekiq_options retry: 0, tags: ['import_keyword']


  def perform(*args)
    begin
      import_history = args[0]
      current_user_id = args[1].id
      import_history.file.open do |file|
        csv = CSV.read(file)
        Keyword.upsert_all(GoogleScraper.call(csv.flatten, current_user_id), unique_by: %i[word user_id])
      end

      import_history.update(status: :success)
    rescue Exception => e

      import_history.update(status: :failed)
    end
  end
end