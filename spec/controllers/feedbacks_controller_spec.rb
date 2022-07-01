require 'rails_helper'

RSpec.describe FeedbacksController do
  before :each do
    @user = User.create(email: 'tes@gmail.com', password: '12345678', role: 2)
    @client = FactoryBot.create(:client, user: @user)
    session[:user_id] = @user.id
    session[:role] = @user.role
    allow(controller).to receive(:current_user) { @client }
    user1 = User.create(email: 'tes12@gmail.com', password: '123456789', role: 1)
    @freelancer = FactoryBot.create(:freelancer, user: user1)
    @feedback = FactoryBot.create(:feedback, freelancer: @freelancer, user: @user)
  end

  describe 'GET #index' do
    it "populates an array of all feedback by user id" do
        feedback1 = create(:feedback, user: @user, freelancer: @freelancer)
        get :index, params: {id_user: @user.id}
        expect(assigns(:feedbacks)).to match_array([@feedback, feedback1])
    end

    it "populates an array of all feedback by user id and freelancer id" do
        feedback1 = create(:feedback, user: @user, freelancer: @freelancer)
        get :index, params: {id_freelancer: @freelancer.id}
        expect(assigns(:feedbacks)).to match_array([@feedback, feedback1])
    end    

    it "populates an array of all feedback by freelancer id" do
        feedback1 = create(:feedback, user: @user, freelancer: @freelancer)
        session[:role] = 0
        get :index, params: {id_freelancer: @freelancer.id}
        expect(assigns(:feedbacks)).to match_array([@feedback, feedback1])
    end 

    it "will give page not found if not throw param user id" do
        get :index
        expect(response).to have_http_status(:not_found)
    end
    
    it "renders the :index template" do
        get :index, params: {id_user: @user.id}
        expect(response).to render_template :index
    end
  end
  describe 'GET #show' do
    it "assigns the requested feedback to @feedback" do
      get :show, params: { id: @feedback }
      expect(assigns(:feedback)).to eq @feedback
    end

    it "renders the :show template" do
      get :show, params: { id: @feedback }
      expect(response).to render_template :show
    end

    it "renders the not found page if request failed to load" do
        get :show, params: {id: 10}
        expect(response).to have_http_status(:not_found)
    end
  end
  describe 'GET #new' do
    it "assigns a new feedback to @feedback" do
      get :new
      expect(assigns(:feedback)).to be_a_new(Feedback)
    end

    it "will renders the form login if not yet login" do
      allow(controller).to receive(:current_user) { nil }
      get :new
      expect(response).to redirect_to form_login_path
    end

    it "[JSON] give status forbidden if not yet login" do
      request.accept = 'application/json'
      allow(controller).to receive(:current_user) { nil }
      get :new
      expect(response).to have_http_status(:forbidden)
    end

    it "renders the :new template" do
      get :new
      expect(response).to render_template :new
    end
  end

  describe 'GET #edit' do
    it "assigns the requested feedback to @feedback" do
      get :edit, params: { id: @feedback }
      expect(assigns(:feedback)).to eq @feedback
    end

    it "renders the :edit template" do
      get :edit, params: { id: @feedback }
      expect(response).to render_template :edit
    end
  end

  describe 'POST #create' do
    context "with valid attributes" do
      it "saves the new feedback in the database" do
        expect{
          post :create, params: { feedback: attributes_for(:feedback, user_id: @user.id, freelancer_id: @freelancer.id) }
        }.to change(Feedback, :count).by(1)
      end

      it "redirects to feedback#show" do
        post :create, params: { feedback: attributes_for(:feedback, user_id: @user.id, freelancer_id: @freelancer.id)}
        expect(response).to redirect_to(feedback_path(assigns[:feedback]))
      end

      it "[JSON] give response found if create success" do
        request.accept = "application/json"
        post :create, params: { feedback: attributes_for(:feedback, user_id: @user.id, freelancer_id: @freelancer.id)}
        expect(response).to have_http_status(:created)
      end
    end

    context "with invalid attributes" do
      it "does not save the new feedback in the database" do
        expect{
          post :create, params: { feedback: attributes_for(:invalid_feedback, user_id: @user.id, freelancer_id: @freelancer.id) }
        }.not_to change(Feedback, :count)
      end

      it "re-renders the :new template" do
        post :create, params: { feedback: attributes_for(:invalid_feedback, user_id: @user.id, freelancer_id: @freelancer.id) }
        expect(response).to render_template :new
      end

      it "[JSON] give response bad request if create failed" do
        request.accept = "application/json"
        post :create, params: { feedback: attributes_for(:invalid_feedback, user_id: @user.id, freelancer_id: @freelancer.id) }
        expect(response).to have_http_status(:unprocessable_entity)
      end
    end

  end

  describe 'PATCH #update' do
    context "with valid attributes" do
      it "locates the requested @feedback" do
        patch :update, params: { id: @feedback, feedback: attributes_for(:feedback, project_name:'personal') }
        expect(assigns(:feedback)).to eq @feedback
      end

      it "changes @feedback's attributes" do
        patch :update, params: { id: @feedback, feedback: attributes_for(:feedback, project_name:'personal') }
        @feedback.reload
        expect(response).to have_http_status(:found)
      end

      it "redirects to the feedback" do
        patch :update, params: { id: @feedback, feedback: attributes_for(:feedback, project_name:'personal') }
        expect(response).to redirect_to @feedback
      end
    end

    context "with invalid attributes" do
      it "does not update the feedback in the database" do
        expect{
          patch :update, params: { id: @feedback, feedback: attributes_for(:invalid_feedback) }
        }.not_to change(Feedback, :count)
        expect(response).to have_http_status(:unprocessable_entity)
      end

      it "re-renders the :edit template" do
        patch :update, params: { id: @feedback, feedback: attributes_for(:invalid_feedback) }
        expect(response).to render_template :edit
      end
    end
  end

  describe 'DELETE #destroy' do

    it "deletes the feedback from the database" do
      expect{
        delete :destroy, params: { id: @feedback }
      }.to change(Feedback, :count).by(-1)
      expect(response).to have_http_status(:found)
    end

    it "redirects to feedbacks#index" do
      delete :destroy, params: { id: @feedback }
      expect(response).to redirect_to "/feedbacks?id_user=#{@user.id}"
    end
  end

  describe 'test Function Rating' do

    it "will give page not found if params id_user blank" do
      get :rating
      expect(response).to have_http_status(:not_found)
    end

    it "give success when rating nil" do
      @feedback.rating = nil
      get :rating, params: {id_user: @freelancer.id}
      expect(response).to have_http_status(:ok)
    end

    it "give success when rating = 10" do
      @feedback.rating = 10
      get :rating, params: {id_user: @freelancer.id}
      expect(response).to have_http_status(:ok)
    end

    it "[JSON] give success when rating = 10" do
      request.accept = 'application/json'
      get :rating, params: {id_user: @freelancer.id}
      expect(response).to have_http_status(:ok)
    end
  end

end