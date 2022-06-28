class UsersController < ApplicationController
  before_action :set_user, only: %i[ show edit update destroy ]
  before_action only: %i[ show edit update destroy ] do
    user_signed_in?
    check_access?(params[:id].to_i, current_user.user_id)
  end

  helper_method :current_user

  # GET /users for html format 
  # GET /users.json for json format
  def index
    @users = User.all
  end

  # GET /users/:id html format
  # GET /users/:id.json for json format
  def show
  end

  # GET /users/new
  def new
    @user = User.new
  end

  # GET /users/:id/edit
  def edit
  end

  # POST /users for html format
  # POST /users.json for json format
  def create
    @user = User.new(user_params)

    respond_to do |format|
      if @user.save
        format.html { redirect_to home_url, notice: "User was successfully created." }
        format.json { render :show, status: :created, location: @user }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @user.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /users/:id for html format
  # PATCH/PUT /users/:id.json for json format
  def update
    respond_to do |format|
      if @user.update(user_params)
        format.html { redirect_to user_url(@user), notice: "Your password has been changed" }
        format.json { render :show, status: :ok, location: @user }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @user.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /users/:id for html format
  # DELETE /users/:id.json for json format
  def destroy
    @user.destroy
    session[:user_id] = nil
    session[:role] = nil

    respond_to do |format|
      format.html { redirect_to home_path, notice: "User was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_user
      @user = User.find_by_id(params[:id])
      if !@user
        not_found
      end
    end

    # Only allow a list of trusted parameters through.
    def user_params
      params.require(:user).permit(:email, :password, :role)
    end
end
