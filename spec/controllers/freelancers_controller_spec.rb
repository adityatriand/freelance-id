require 'rails_helper'

RSpec.describe FreelancersController do
  let(:user){
    FactoryBot.create(:user, role: 2)
  }
  subject(:freelancer){
    FactoryBot.create(:freelancer, user: user)
  }
  describe 'GET #index' do
      it "populates an array of all freelancers" do
          freelancer1 = create(:freelancer, phone: "089612345678", user: user)
          freelancer2 = create(:freelancer, phone: "089612345679", user: user)
          get :index
          expect(assigns(:freelancers)).to match_array([freelancer1, freelancer2])
      end

      it "renders the :index template" do
          get :index
          expect(response).to render_template :index
      end
  end

  describe 'GET #show' do
    it "assigns the requested freelancer to @freelancer" do
      get :show, params: { id: freelancer }
      expect(assigns(:freelancer)).to eq freelancer
    end

    it "renders the :show template" do
      get :show, params: { id: freelancer }
      expect(response).to render_template :show
    end

    it "renders the not found page if request failed to load" do
        get :show, params: {id: 1}
        expect(response).to have_http_status(:not_found)
    end
  end

  describe 'GET #new' do
    it "assigns a new freelancer to @freelancer" do
      get :new
      expect(assigns(:freelancer)).to be_a_new(Freelancer)
    end

    it "renders the :new template" do
      get :new
      expect(:response).to render_template :new
    end
  end

  describe 'GET #edit' do
    it "assigns the requested freelancer to @freelancer" do
      get :edit, params: { id: freelancer }
      expect(assigns(:freelancer)).to eq freelancer
    end

    it "renders the :edit template" do
      get :edit, params: { id: freelancer }
      expect(response).to render_template :edit
    end
  end

  describe 'POST #create' do
    context "with valid attributes" do
      it "saves the new freelancer in the database" do
        expect{
          post :create, params: { freelancer: attributes_for(:freelancer, user_id: user.id) }
        }.to change(Freelancer, :count).by(1)
      end

      it "redirects to freelancers#show" do
        post :create, params: { freelancer: attributes_for(:freelancer, user_id: user.id)}
        expect(response).to redirect_to(freelancer_path(assigns[:freelancer]))
      end

      it "give response created if create success" do
        post :create, params: { freelancer: attributes_for(:freelancer, user_id: user.id)}
        expect(response).to have_http_status(:found)
      end

    end

    context "with invalid attributes" do
      it "does not save the new freelancer in the database" do
        expect{
          post :create, params: { freelancer: attributes_for(:invalid_freelancer, user_id: user.id) }
        }.not_to change(Freelancer, :count)
      end

      it "re-renders the :new template" do
        post :create, params: { freelancer: attributes_for(:invalid_freelancer, user_id: user.id) }
        expect(response).to render_template :new
      end

      it "give response bad request if create failed" do
        post :create, params: { freelancer: attributes_for(:invalid_freelancer, user_id: user.id) }
        expect(response).to have_http_status(:unprocessable_entity)
      end

    end
  end

  describe 'PATCH #update' do
    before :each do
      @freelancer = create(:freelancer, user: user)
    end

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

  describe 'DELETE #destroy' do
    before :each do
      @freelancer = create(:freelancer, user: user)
    end

    it "deletes the freelancer from the database" do
      expect{
        delete :destroy, params: { id: @freelancer }
      }.to change(Freelancer, :count).by(-1)
      expect(response).to have_http_status(:found)
    end

    it "redirects to freelancers#index" do
      delete :destroy, params: { id: @freelancer }
      expect(response).to redirect_to freelancers_url
    end
  end
end