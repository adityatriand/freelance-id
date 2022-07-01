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
      if session[:role] == 2
        @feedbacks = Feedback.where(freelancer_id: params[:id_freelancer], user_id: current_user.user_id)
      else
        @feedbacks = Feedback.where(freelancer_id: params[:id_freelancer])  
      end
    else
      not_found
    end
  end

  def rating
    if !params[:id_user].blank?
      check_access?(current_user.id, params[:id_user].to_i)
      overall_rating = Feedback.count_rating(params[:id_user].to_i)
      if overall_rating.nil?
        overall_rating = 0
      end
      atr_rating = check_rating(overall_rating)
      respond_to do |format|
        format.html { render '/freelancers/rating', locals: {rating: overall_rating, atr_rating: atr_rating} }
        format.json { 
            render json:{
                message: 'This value is overall rating from client',
                rating: overall_rating
            }, status: :ok 
        }
      end
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
      format.html { redirect_to "/feedbacks?id_user=#{session[:user_id]}", notice: "Feedback was successfully destroyed." }
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

    def check_rating(value)
      atr_rating = {
        color: nil,
        status: nil,
        message: nil
      }
      if value == 10
        atr_rating[:color] = 'bg-success'
        atr_rating[:status] = 'Very Good'
        atr_rating[:message] = 'Your performance is very good. Maintain and continue to do the work of the client as well as possible'
      elsif value > 6 && value < 10
        atr_rating[:color] = 'bg-success'
        atr_rating[:status] = 'Good'
        atr_rating[:message] = 'Your performance is good. Improve or maintain it by continuing to create a portfolio and do the work of the client well'
      elsif value > 0 && value < 6
        atr_rating[:color] = 'bg-warning'
        atr_rating[:status] = 'Enough'
        atr_rating[:message] = 'your performance is quite good. Let\'s improve it again by creating a portfolio so that many clients will be interested and give a good rating'
      else
        atr_rating[:color] = 'bg-danger'
        atr_rating[:status] = 'Need Improve'
        atr_rating[:message] = 'Your performance needs to be improved. Let\'s improve it by creating a portfolio so that many clients will be interested and give a good rating'
      end
      return atr_rating
    end
end
