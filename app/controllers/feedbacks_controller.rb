class FeedbacksController < ApplicationController
  before_action :set_feedback, only: %i[ show edit update destroy ]
  before_action only: %i[ new create edit update destroy ] do
    user_signed_in?
  end

  helper_method :current_user

  # GET /feedbacks or /feedbacks.json
  def index
    if !params[:id_user].blank?
      check_access?(current_user.user_id, params[:id_user].to_i)
      @feedbacks = Feedback.where(user_id: params[:id_user])
    elsif !params[:id_freelancer].blank?
      @feedbacks = Feedback.where(freelancer_id: params[:id_freelancer])
    else
      not_found
    end
  end

  # GET /feedbacks/1 or /feedbacks/1.json
  def show
  end

  # GET /feedbacks/new
  def new
    check_access?(session[:role],2)
    @feedback = Feedback.new
  end

  # GET /feedbacks/1/edit
  def edit
    check_access?(current_user.user_id, @feedback.user_id)
  end

  # POST /feedbacks or /feedbacks.json
  def create
    check_access?(session[:role],2)
    @feedback = Feedback.new(feedback_params)
    @feedback.user_id = session[:user_id]

    respond_to do |format|
      if @feedback.save
        format.html { redirect_to feedback_url(@feedback), notice: "Feedback was successfully created." }
        format.json { render :show, status: :created, location: @feedback }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @feedback.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /feedbacks/1 or /feedbacks/1.json
  def update
    check_access?(current_user.user_id, @feedback.user_id)
    respond_to do |format|
      if @feedback.update(feedback_params)
        format.html { redirect_to feedback_url(@feedback), notice: "Feedback was successfully updated." }
        format.json { render :show, status: :ok, location: @feedback }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @feedback.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /feedbacks/1 or /feedbacks/1.json
  def destroy
    check_access?(current_user.user_id, @feedback.user_id)
    @feedback.destroy

    respond_to do |format|
      format.html { redirect_to "/feedbacks?id_client=#{session[:user_id]}", notice: "Feedback was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_feedback
      @feedback = Feedback.find_by_id(params[:id])
      if !@feedback
        not_found
      end
    end

    # Only allow a list of trusted parameters through.
    def feedback_params
      params.require(:feedback).permit(:project_name, :description, :link_project, :testimoni, :rating, :freelancer_id)
    end
end
