# frozen_string_literal: true

class Model1s::SessionsController < Devise::SessionsController
  # before_action :configure_sign_in_params, only: [:create]

  def new
    @chat_id=params[:chat_id]
    super
  end

  def create
    chat_id = params[:model1][:chatid]
    self.resource = warden.authenticate!(auth_options)
    set_flash_message(:notice, :signed_in) if is_navigational_format?
    sign_in(resource_name, resource)
    if !session[:return_to].blank?
      redirect_to session[:return_to]
      session[:return_to] = nil
    else
      respond_with resource, :location => after_sign_in_path_for(resource)
      if chat_id.present?
        if current_model1.chatid.nil? 
          chatid_user = Model1.find_by(chatid: chat_id)
          if chatid_user.nil?
            current_model1.update(chatid: chat_id) if current_model1
            flash[:alert] = 'Телеграм успешно привязан к вашему аккаунту'
          else
            flash[:alert] = 'Данный телеграм уже привязан к другому аккаунту, для продолжения сначала отвяжите от другого аккаунта'
          end
        else
          flash[:alert] = 'К вашему аккаунту уже привязан telegram, сбросить можно в вашем профиле на сайте'
        end

      end
    end
  end
  # DELETE /resource/sign_out
  # def destroy
  #   super
  # end

  # protected

  # If you have extra params to permit, append them to the sanitizer.
  # def configure_sign_in_params
  #   devise_parameter_sanitizer.permit(:sign_in, keys: [:attribute])
  # end
end
