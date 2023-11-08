class CsvImport
  include ActiveModel::Model
  attr_reader :file

  MAX_KEYWORD = 100

  validate :validate_file_presence
  validate :validate_csv_file,         if: ->(file) { !file.file.nil?}

  def initialize(file)
    @file = file
  end

  private

  def validate_file_presence
    errors.add(:base, I18n.t('errors.file_not_found')) if @file.nil?
  end

  def validate_csv_file
    begin
      csv_file = CSV.read(@file)
      errors.add(:base, I18n.t('errors.maximum_keywords')) if csv_file.flatten.size > MAX_KEYWORD
    rescue CSV::MalformedCSVError
      errors.add(:base, I18n.t('errors.file_type_invalid'))
    end
  end
end