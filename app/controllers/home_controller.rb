class HomeController < ApplicationController

  helper_method :current_user

  def index
    if session[:user_id]
      set_page
    else
      render 'index'
    end
  end

  private
    def set_page
      if session[:role] == 1
        if defined?(current_user.name)
          render 'freelancer'
        else
          respond_to do |format|
              format.html { redirect_to new_freelancer_path }
              format.json { 
                render json:{
                    status: 'Not Completed',
                    message: 'You must completed your profile first such as name,phone,date_birth, and category_work'
                }, 
                status: :found
              }
          end
        end
      else
        if defined?(current_user.name)
          render 'client'
        else
          respond_to do |format|
              format.html { redirect_to new_client_path }
              format.json { 
                render json:{
                    status: 'Not Completed',
                    message: 'You must completed your profile first such as name,phone,date_birth, and type_industry'
                }, 
                status: :found
              }
          end
        end
      end
    end

end
