class ApplicationController < ActionController::API
  delegate :t, to: I18n

  before_action :doorkeeper_authorize!

  def current_user
    @current_user ||= User.find_by(id: doorkeeper_token.resource_owner_id) if doorkeeper_token.present?
  end

  def render_ok(data = { message: t('ok') })
    render status: :ok, json: data
  end

  def render_created(data = { message: t('created') })
    render status: :created, json: data
  end

  def render_bad_request(data = { message: t('bad_request') })
    render status: :bad_request, json: data
  end

  def render_forbidden(data = { message: t('forbidden') })
    render status: :forbidden, json: data
  end

  def render_not_found(data = { message: t('not_found') })
    render status: :not_found, json: data
  end

  def strip_params(values)
    values.each_value { |value| value.strip! if value.instance_of?(String) }
  end
end
