require 'csv'

class Api::V1::ImportHistoriesController < ApplicationController

  def index
    import_histories = ImportHistory.where(user_id: current_user.id)
    render_ok({import_hisotry: import_histories.as_json})
  end

  def upload
    return render_bad_request(message: t('errors.file_not_found')) if import_params["file"].nil?

    import_file = import_params[:file]
    filename = import_file.original_filename
    return render_bad_request(
      message: t('errors.file_type_invalid')
    ) unless is_import_csv(import_file)

    import = ImportHistory.new(
      import_params.merge({
        filename:,
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

  def is_import_csv(csv)
    begin
      CSV.read(csv)
    rescue CSV::MalformedCSVError => e
      log_error(e)

      return false
    end
    
    return true
  end
end
