class FreelancersController < ApplicationController
  before_action :set_freelancer, only: %i[ show edit update destroy ]
  before_action only: %i[ edit update destroy ] do
    user_signed_in?
    check_access?(params[:id].to_i, current_user.id)
  end

  helper_method :current_user

  # GET /freelancers for html format
  # GET /freelancers.json for json format
  def index
    if !params[:search].blank?
      @freelancers = Freelancer.where(category_work: params[:search])
    else
      @freelancers = Freelancer.all
    end
  end

  # GET /freelancers/:id for html format
  # GET /freelancers/:id.json for json format
  def show
  end

  # GET /freelancers/new
  def new
    if session[:user_id].nil?
      not_found
    else
      if !current_user.nil?
        redirect_to home_path
      else
        @freelancer = Freelancer.new
      end
    end
  end

  # GET /freelancers/1/edit
  def edit
  end

  # POST /freelancers for html format 
  # POST /freelancers.json for json format
  def create
    if session[:user_id].nil?
      not_found
    else
      if !current_user.nil?
        respond_to do |format|
            format.html { redirect_to home_path }
            format.json { 
              render json:{
                  status: 'Completed',
                  message: 'Your profile has been completed'
              }, 
              status: :found
            }
        end
      else
        @freelancer = Freelancer.new(freelancer_params)
        @freelancer.user_id = session[:user_id]

        respond_to do |format|
          if @freelancer.save
            format.html { redirect_to home_path, notice: "Your Profile Has Been Completed." }
            format.json { render :show, status: :created, location: @freelancer }
          else
            format.html { render :new, status: :unprocessable_entity }
            format.json { render json: @freelancer.errors, status: :unprocessable_entity }
          end
        end
      end
    end
  end

  # PATCH/PUT /freelancers/:id for html format
  # PATCH/PUT /freelancers/:id.json for json format
  def update
    respond_to do |format|
      if @freelancer.update(freelancer_params)
        format.html { redirect_to freelancer_url(@freelancer), notice: "Freelancer was successfully updated." }
        format.json { render :show, status: :ok, location: @freelancer }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @freelancer.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /freelancers/1 for html format
  # DELETE /freelancers/1.json for json format
  def destroy
    @freelancer.destroy

    respond_to do |format|
      format.html { redirect_to freelancers_url, notice: "Freelancer was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_freelancer
      @freelancer = Freelancer.find_by_id(params[:id])
      if !@freelancer
        not_found
      end
    end

    # Only allow a list of trusted parameters through.
    def freelancer_params
      params.require(:freelancer).permit(:name, :phone, :date_birth, :category_work)
    end
end
