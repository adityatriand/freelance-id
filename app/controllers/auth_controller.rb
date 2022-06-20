class AuthController < ApplicationController
    def login
        email = params[:email]
        password = params[:password]
        
        user = User.find_by(email: email)
        if user
            if user.authenticate(password)
                session[:user_id] = user.id
                render json: {
                    status: 'success',
                    message: 'You are logged in',
                    data: user,
                }, status: :ok
            else
                render json: {
                    status: 'fail',
                    message: 'You are failed to login',
                }, status: :unauthorized
            end
        else
            render json: {
                status: 'fail',
                message: 'User not found',
            }, status: :unauthorized
        end
    end

    def logout
        session[:user_id] = nil
        render json: {
            status: 'success',
            message: 'You are logged out'
        }, status: :ok
    end
end