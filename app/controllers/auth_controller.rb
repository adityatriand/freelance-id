class AuthController < ApplicationController
    
    helper_method :current_user
    
    def form_login

    end

    def login
        email = params[:email]
        password = params[:password]
        
        user = User.find_by(email: email)
        respond_to do |format|
            if user
                if user.authenticate(password)
                    session[:user_id] = user.id
                    session[:role] = user.role
                    format.html { redirect_to home_path, notice: "Welcome #{user.email}" }
                    format.json { 
                        render json:{
                            status: 'success',
                            message: 'You are logged in',
                            data: current_user,
                            csrf: session[:_csrf_token]
                        }, status: :ok 
                    }
                else
                    format.html { redirect_to form_login_path, alert: "Email or Password Wrong" }
                    format.json { 
                        render json: {
                            status: 'fail',
                            message: 'You are failed to login',
                        }, status: :unauthorized 
                    }
                end
            else
                format.html { redirect_to form_login_path, alert: "User not found" }
                format.json { 
                    render json: {
                        status: 'fail',
                        message: 'User not found',
                    }, status: :unauthorized 
                }
            end
        end
    end

    def logout
        session[:user_id] = nil
        session[:role] = nil
        respond_to do |format|
            format.html { redirect_to home_path, notice: "You are logged out" }
            format.json { 
                render json: {
                    status: 'success',
                    message: 'You are logged out'
                }, status: :ok 
            }
        end
    end
end