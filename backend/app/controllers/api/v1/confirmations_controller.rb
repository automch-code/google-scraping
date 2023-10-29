class Api::V1::ConfirmationsController < Devise::ConfirmationsController
  skip_before_action :doorkeeper_authorize!

  def create
    self.resource = resource_class.send_confirmation_instructions(params)
    if resource.errors.empty?
      render_ok(message: t('devise.confirmations.send_instructions'))
    else
      render_bad_request(message: resource.errors.full_messages.uniq.join(', '))
    end
  end

  def show
    self.resource = resource_class.confirm_by_token(params[:confirmation_token])
    if resource.errors.empty?
      render_ok(message: t('devise.confirmations.confirmed'))
    else
      render_bad_request(message: resource.errors.full_messages.uniq.join(', '))
    end
  end
end