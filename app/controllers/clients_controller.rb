class ClientsController < ApplicationController
  before_action :set_client, only: %i[ show edit update destroy ]
  before_action only: %i[ edit update destroy ] do
    user_signed_in?
    check_access?(params[:id].to_i, current_user.id)
  end

  helper_method :current_user

  # GET /clients for html format
  # GET /clients.json for json format
  def index
    @clients = Client.all
  end

  # GET /clients/:id for html format
  # GET /clients/:id.json for json format
  def show
  end

  # GET /clients/new
  def new
    if session[:user_id].nil?
      not_found
    else
      if !current_user.nil?
        redirect_to home_path
      else
        @client = Client.new
      end
    end
  end

  # GET /clients/1/edit
  def edit
  end

  # POST /clients for html format
  # POST /clients.json for json format
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
        @client = Client.new(client_params)
        @client.user_id = session[:user_id]

        respond_to do |format|
          if @client.save
            format.html { redirect_to home_path, notice: "Your Profile Has Been Completed." }
            format.json { render :show, status: :created, location: @client }
          else
            format.html { render :new, status: :unprocessable_entity }
            format.json { render json: @client.errors, status: :unprocessable_entity }
          end
        end
      end
    end
  end

  # PATCH/PUT /clients/:id for html format
  # PATCH/PUT /clients/:id.json for json format
  def update
    respond_to do |format|
      if @client.update(client_params)
        format.html { redirect_to client_url(@client), notice: "Client was successfully updated." }
        format.json { render :show, status: :ok, location: @client }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @client.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /clients/:id for html format
  # DELETE /clients/:id.json for json format
  def destroy
    @client.destroy

    respond_to do |format|
      format.html { redirect_to clients_url, notice: "Client was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_client
      @client = Client.find_by_id(params[:id])
      if !@client
        not_found
      end
    end

    # Only allow a list of trusted parameters through.
    def client_params
      params.require(:client).permit(:name, :phone, :date_birth, :type_industry)
    end
end
