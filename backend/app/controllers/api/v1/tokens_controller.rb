class Api::V1::TokensController < Doorkeeper::TokensController
  def create
    unless authorize_response.token.resource_owner&.active?
      return render_bad_request(error_description: I18n.t('doorkeeper.errors.messages.inactive_user'))
    end

    super
  rescue NoMethodError, Doorkeeper::Errors::InvalidTokenStrategy
    super
  end

  private

  def render_bad_request(data = { error_description: I18n.t('bad_request') })
    render status: :bad_request, json: data
  end
end