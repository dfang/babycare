# frozen_string_literal: true

class Users::RegistrationsController < Devise::RegistrationsController
  # before_action :configure_sign_up_params, only: [:create]
  before_action :configure_account_update_params, only: [:update]

  def validate_phone; end

  def send_verification_code
    # https://github.com/bbatsov/ruby-style-guide#underscores-in-numerics
    verification_code = Random.new.rand(0o00000...999_999)
    IM::Ronglian.new.send_templated_sms(params[:mobile_phone], Settings.sms_templates.notify_user_when_reserved, verification_code)

    Rails.logger.info "verification_code:#{verification_code}"
  end

  # def show
  # end

  def update
    # 区分是绑定手机号还是更新个人资料
    if params.key?(:user) && params[:user].key?(:captcha)
      # 取出 mobile_phone, 并更新当前的手机号
      mobile_phone = params[:user][:mobile_phone]
      current_user.update(mobile_phone: mobile_phone)
      redirect_to(bind_phone_success_path) && return
    else
      # binding.pry
      current_user.update(params[:user].permit!)
      redirect_to(update_success_path) && return
    end
  end

  def update_success; end

  def bind_phone_success; end

  # GET /resource/sign_up
  # def new
  #   super
  # end

  # POST /resource
  # def create
  #   super
  # end

  # GET /resource/edit
  # def edit
  #   super
  # end

  # PUT /resource
  # def update
  #   super
  # end

  # def update
  #   self.resource = resource_class.to_adapter.get!(send(:"current_#{resource_name}").to_key)
  #   prev_unconfirmed_email = resource.unconfirmed_email if resource.respond_to?(:unconfirmed_email)
  #
  #   binding.pry
  #   resource_updated = update_resource(resource, account_update_params)
  #   yield resource if block_given?
  #   if resource_updated
  #     if is_flashing_format?
  #       flash_key = update_needs_confirmation?(resource, prev_unconfirmed_email) ?
  #         :update_needs_confirmation : :updated
  #       set_flash_message :notice, flash_key
  #     end
  #     sign_in resource_name, resource, bypass: true
  #     respond_with resource, location: after_update_path_for(resource)
  #   else
  #     clean_up_passwords resource
  #     respond_with resource
  #   end
  # end

  # DELETE /resource
  # def destroy
  #   super
  # end

  # GET /resource/cancel
  # Forces the session data which is usually expired after sign
  # in to be expired now. This is useful if the user wants to
  # cancel oauth signing in/up in the middle of the process,
  # removing all OAuth session data.
  # def cancel
  #   super
  # end

  protected

  # If you have extra params to permit, append them to the sanitizer.
  # def configure_sign_up_params
  #   devise_parameter_sanitizer.permit(:sign_up, keys: [:attribute])
  # end

  # If you have extra params to permit, append them to the sanitizer.
  def configure_account_update_params
    devise_parameter_sanitizer.permit(:account_update, keys: %i[name mobile_phone location birthdate gender])
  end

  def after_update_path_for(_resource)
    patients_path
  end

  # The path used after sign up.
  # def after_sign_up_path_for(resource)
  #   super(resource)
  # end

  # The path used after sign up for inactive accounts.
  # def after_inactive_sign_up_path_for(resource)
  #   super(resource)
  # end
  def update_resource(resource, params)
    resource.update_without_password(params)
  end
end
