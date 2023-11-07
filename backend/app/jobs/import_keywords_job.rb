require 'csv'

class ImportKeywordsJob < ApplicationJob
  queue_as :default
  sidekiq_options retry: 0, tags: ['import_keyword']


  def perform(*args)
    import_history = args[0]
    current_user_id = args[1].id
    import_history.file.open do |file|
      csv = CSV.read(file)
      csv.flatten.each do |keyword|
        Keyword.create(word: keyword, user_id: current_user_id)
      end
    end
    
    import_history.update(status: :success)
  end
end