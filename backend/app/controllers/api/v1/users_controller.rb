# frozen_string_literal: true

class Api::V1::UsersController < ApplicationController
  skip_before_action :doorkeeper_authorize!,   only: :registration
  before_action :find_by_email,                only: %i[registration]
  before_action :on_create_params,             only: %i[registration]

  def registration
    if @user.nil?
      @user = User.new(@user_params.merge(role: User.roles[:user]))
      
      return render_created(user: @user, message: t('user.success.registered')) if @user.save
    elsif @user.update(@user_params)
      return render_ok(user: @user, message: t('user.success.registered'))
    end

    render_bad_request(message: @user.errors.full_messages.uniq.join(', '))
  end

  private

  def find_by_email
    @user = User.find_by(email: params[:user][:email])
  end

  def on_create_params
    user_params(%i[email password password_confirmation])
  end

  def user_params(permit_keys = [])
    @user_params = strip_params(
      params.require(:user).permit(
        %i[role_id] + permit_keys
      )
    )
  end
end