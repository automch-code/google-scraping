class ImportKeywordsJob < ApplicationJob
  queue_as :default
  sidekiq_options retry: 0, tags: ['import_keyword']


  def perform(*args)
    import_history = args[0]
    current_user_id = args[1].id
    import_history.file.open do |file|
      csv = CSV.read(file)

      #FIXME not a good thing to do for update, find another
      Keyword.where(word: csv.flatten, user_id: current_user_id).destroy_all
      Keyword.insert_all(GoogleScraper.call(csv.flatten, current_user_id))
    end
  end
end