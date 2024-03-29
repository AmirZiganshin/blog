class UsersController < ApplicationController
    before_action :authenticate_user!
    def allusers
        if model1_signed_in? && (current_model1.admin?)
            @users=Model1.all
        else
            redirect_to posts_path, alert: 'Отказано в доступе'
        end
    end

    def search
        if model1_signed_in && (current_model1.admin?)
            @users = Model1.where("email LIKE ?", "%#{params[:query]}%")
        else
            redirect_to posts_path, alert: 'Отказано в доступе'
        end
    end

    def authenticate_user!
        redirect_to new_model1_session_path, alert:"Зарегистрируйтесь чтобы получить доступ ко всем функциям" unless model1_signed_in?
    end

    def update
        @user = Model1.find(params[:id])
        if model1_signed_in? && (current_model1.admin?)
            if(@user.update(user_params))
                redirect_to allusers_path
            else
                redirect_to allusers_path, alert: 'Произошла ошибка'
            end
        else
            redirect_to posts_path, alert: 'Отказано в доступе'
        end
    end

    private def user_params
        params.require(:model1).permit(:role)
    end

end
