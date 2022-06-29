class PortofoliosController < ApplicationController
  before_action :set_portofolio, only: %i[ show edit update destroy ]
  before_action only: %i[ new create edit update destroy ] do
    user_signed_in?
  end

  helper_method :current_user

  # GET /portofolios or /portofolios.json
  def index
    if !params[:id_user].blank?
      @portofolios = Portofolio.where(user_id: params[:id_user])
    else
      not_found
    end
  end

  # GET /portofolios/1 or /portofolios/1.json
  def show
  end

  # GET /portofolios/new
  def new
    check_access?(session[:role],1)
    @portofolio = Portofolio.new
  end

  # GET /portofolios/1/edit
  def edit
    check_access?(current_user.user_id, @portofolio.user_id)
  end

  # POST /portofolios or /portofolios.json
  def create
    check_access?(session[:role],1)
    @portofolio = Portofolio.new(portofolio_params)
    @portofolio.user_id = session[:user_id]

    respond_to do |format|
      if @portofolio.save
        format.html { redirect_to portofolio_url(@portofolio), notice: "Portofolio was successfully created." }
        format.json { render :show, status: :created, location: @portofolio }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @portofolio.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /portofolios/1 or /portofolios/1.json
  def update
    check_access?(current_user.user_id, @portofolio.user_id)
    respond_to do |format|
      if @portofolio.update(portofolio_params)
        format.html { redirect_to portofolio_url(@portofolio), notice: "Portofolio was successfully updated." }
        format.json { render :show, status: :ok, location: @portofolio }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @portofolio.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /portofolios/1 or /portofolios/1.json
  def destroy
    check_access?(current_user.user_id, @portofolio.user_id)
    @portofolio.destroy

    respond_to do |format|
      format.html { redirect_to "/portofolios?id_user=#{session[:user_id]}", notice: "Portofolio was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_portofolio
      @portofolio = Portofolio.find_by_id(params[:id])
      if !@portofolio
        not_found
      end
    end

    # Only allow a list of trusted parameters through.
    def portofolio_params
      params.require(:portofolio).permit(:title, :description, :type_project, :client_name, :client_industry, :link_url, :porto_attachment)
    end
end
