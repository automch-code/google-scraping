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
        keyword_record = find_keyword(keyword, current_user_id)
        
        if keyword_record.nil?
          Keyword.create(word: keyword, user_id: current_user_id)
        else
          keyword_record.update(status: :pending)
        end
      end
    end
    
    import_history.update(status: :success)
  end

  private

  def find_keyword(keyword, current_user_id)
    Keyword.find_by(word: keyword, user_id: current_user_id)
  end
end