require 'rails_helper'

RSpec.describe FreelancersController do
  before :each do
    @user = User.create(email: 'tes@gmail.com', password: '12345678', role: 1)
    @freelancer = FactoryBot.create(:freelancer, user: @user)
    session[:user_id] = @user.id
    session[:role] = @user.role
    allow(controller).to receive(:current_user) { @freelancer }
  end
  describe 'GET #index' do
      it "populates an array of all freelancers" do
          freelancer1 = create(:freelancer, phone: "089612345678", user: @user)
          get :index
          expect(assigns(:freelancers)).to match_array([@freelancer, freelancer1])
      end

      it "populates an array of all freelancers with category work" do
          freelancer1 = create(:freelancer, phone: "089612345678", category_work: "Designer", user: @user)
          get :index, params: { search: 'Designer' }
          expect(assigns(:freelancers)).to match_array([freelancer1])
      end
        
      it "renders the :index template" do
          get :index
          expect(response).to render_template :index
      end
  end

  describe 'GET #show' do
    it "assigns the requested freelancer to @freelancer" do
      get :show, params: { id: @freelancer }
      expect(assigns(:freelancer)).to eq @freelancer
    end

    it "renders the :show template" do
      get :show, params: { id: @freelancer }
      expect(response).to render_template :show
    end

    it "renders the not found page if request failed to load" do
        get :show, params: {id: 10}
        expect(response).to have_http_status(:not_found)
    end
  end

  describe 'GET #new' do
    it "assigns a new freelancer to @freelancer" do
      allow(controller).to receive(:current_user) { nil }
      get :new
      expect(assigns(:freelancer)).to be_a_new(Freelancer)
    end

    it "will renders the home path if already create freelancer profil" do
      get :new
      expect(response).to redirect_to home_path
    end

    it "will response not found if not login" do
      session[:user_id] = nil
      session[:role] = nil
      allow(controller).to receive(:current_user) { nil }
      get :new
      expect(response).to have_http_status(:not_found)
    end

    it "renders the :new template" do
      allow(controller).to receive(:current_user) { nil }
      get :new
      expect(response).to render_template :new
    end
  end

  describe 'GET #edit' do
    it "assigns the requested freelancer to @freelancer" do
      get :edit, params: { id: @freelancer }
      expect(assigns(:freelancer)).to eq @freelancer
    end

    it "renders the :edit template" do
      get :edit, params: { id: @freelancer }
      expect(response).to render_template :edit
    end
  end

  describe 'POST #create' do
    context "with valid attributes" do
      it "saves the new freelancer in the database" do
        allow(controller).to receive(:current_user) { nil }
        expect{
          post :create, params: { freelancer: attributes_for(:freelancer, user_id: @user.id) }
        }.to change(Freelancer, :count).by(1)
      end

      it "redirects to freelancers#show" do
        allow(controller).to receive(:current_user) { nil }
        post :create, params: { freelancer: attributes_for(:freelancer, user_id: @user.id)}
        expect(response).to redirect_to home_path
      end

      it "redirects to home path if already create freelancer profile" do
        post :create, params: { freelancer: attributes_for(:freelancer, user_id: @user.id)}
        expect(response).to redirect_to home_path
      end

      it "give response found if create success" do
        allow(controller).to receive(:current_user) { nil }
        post :create, params: { freelancer: attributes_for(:freelancer, user_id: @user.id)}
        expect(response).to have_http_status(:found)
      end

      it "[JSON] give response found if create success" do
        request.accept = "application/json"
        post :create, params: { freelancer: attributes_for(:freelancer, user_id: @user.id)}
        expect(response).to have_http_status(:found)
      end

    end

    context "with invalid attributes" do
      it "does not save the new freelancer in the database" do
        allow(controller).to receive(:current_user) { nil }
        expect{
          post :create, params: { freelancer: attributes_for(:invalid_freelancer, user_id: @user.id) }
        }.not_to change(Freelancer, :count)
      end

      it "give response not found if not yet login" do
        session[:user_id] = nil
        session[:role] = nil
        allow(controller).to receive(:current_user) { nil }
        post :create, params: { freelancer: attributes_for(:freelancer, user_id: @user.id)}
        expect(response).to have_http_status(:not_found)
      end

      it "re-renders the :new template" do
        allow(controller).to receive(:current_user) { nil }
        post :create, params: { freelancer: attributes_for(:invalid_freelancer, user_id: @user.id) }
        expect(response).to render_template :new
      end

      it "give response bad request if create failed" do
        allow(controller).to receive(:current_user) { nil }
        post :create, params: { freelancer: attributes_for(:invalid_freelancer, user_id: @user.id) }
        expect(response).to have_http_status(:unprocessable_entity)
      end

    end
  end

  describe 'PATCH #update' do
    context "with valid attributes" do
      it "locates the requested @freelancer" do
        patch :update, params: { id: @freelancer, freelancer: attributes_for(:freelancer) }
        expect(assigns(:freelancer)).to eq @freelancer
      end

      it "changes @freelancer's attributes" do
        patch :update, params: { id: @freelancer, freelancer: attributes_for(:freelancer) }
        @freelancer.reload
        expect(response).to have_http_status(:found)
      end

      it "redirects to the freelancer" do
        patch :update, params: { id: @freelancer, freelancer: attributes_for(:freelancer) }
        expect(response).to redirect_to @freelancer
      end
    end

    context "with invalid attributes" do
      it "does not update the freelancer in the database" do
        expect{
          patch :update, params: { id: @freelancer, freelancer: attributes_for(:invalid_freelancer) }
        }.not_to change(Freelancer, :count)
        expect(response).to have_http_status(:unprocessable_entity)
      end

      it "re-renders the :edit template" do
        patch :update, params: { id: @freelancer, freelancer: attributes_for(:invalid_freelancer) }
        expect(response).to render_template :edit
      end
    end
  end


end