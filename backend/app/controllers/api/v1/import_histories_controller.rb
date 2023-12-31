require 'csv'

class Api::V1::ImportHistoriesController < ApplicationController
  before_action :upload_validation,         only: [:upload]

  def index
    import_histories = ImportHistory.where(filter)
      .where(user_id: current_user.id)
      .limit(limit)
      .order(order_list)
      .offset(offset)
      .as_json

    render_ok({import_hisotry: import_histories.as_json})
  end

  def upload
    import = ImportHistory.new(
      import_params.merge({
        filename: import_params[:file].original_filename,
        user_id: current_user.id
      }))

    if import.save
      ImportKeywordsJob.perform_later(import, current_user)
      render_accepted(
        import_history: import.id,
        message: t('import_history.processing', filename: import.filename)
      )
    else
      render_bad_request(message: import.errors.full_messages.join(', '))
    end
  end

  private

  def import_params
    params.require(:import).permit(%i[file])
  end

  def upload_validation
    return render_bad_request(message: t('errors.file_not_found')) if import_params[:file].nil?

    begin
      CSV.read(import_params[:file])
    rescue CSV::MalformedCSVError => e
      log_error(e)

      return render_bad_request(message: t('errors.file_type_invalid'))
    end
  end

  def order_list
    order_query = nil

    if params[:updated_at].present?
      order_query = "updated_at #{params[:updated_at].upcase}"
    else
      order_query = "created_at #{params[:created_at] || 'DESC'}"
    end

    order_query
  end

  def filter
    return {} if params[:query].blank?

    [
      'import_histories.filename'
    ].map { |attr| "#{attr} LIKE '%#{ImportHistory.sanitize_sql_like(params[:query].strip)}%'" }.join(' OR ')
  end
end
