class ApplicationController < ActionController::Base
    protect_from_forgery with: :null_session
    skip_before_action :verify_authenticity_token
    
     def current_user
        if session[:user_id]
            if session[:role] == 1
                Freelancer.find_by_user_id(session[:user_id])
            elsif session[:role] == 2
                Client.find_by_user_id(session[:user_id])
            end
        else
            nil
        end
    end

    def user_signed_in?
        if current_user
            true
        else
            respond_to do |format|
                format.html { redirect_to form_login_path, alert: "You must login first!" }
                format.json { 
                    render json:{
                        status: 'Authorized',
                        message: 'You must login first!'
                    }, status: :forbidden 
                }
            end
            return false
        end
    end

    def check_access?(id1,id2)
      if id1 == id2
        true
      else
        not_found
        return false
      end
    end

    def not_found
        respond_to do |format|
            format.html { render :file => "#{Rails.root}/public/404.html", :layout => false, :status => :not_found }
            format.json { render json: { error: 'Page not found' }, status: :not_found }
        end
    end
    
end
