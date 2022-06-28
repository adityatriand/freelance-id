require 'rails_helper'

RSpec.describe UsersController do
  before :each do
    @user = User.create(email: 'tes@gmail.com', password: '12345678', role: 1)
    @freelancer = FactoryBot.create(:freelancer, user: @user)
    allow(controller).to receive(:current_user) { @freelancer }
  end

  describe 'GET #show' do
    it "assigns the requested user to @user" do
      get :show, params: { id: @user }
      expect(assigns(:user)).to eq @user
    end

    it "renders the :show template" do
      get :show, params: { id: @user }
      expect(response).to render_template :show
    end

    it "renders the not found page if request failed to load" do
        get :show, params: {id: 10}
        expect(response).to have_http_status(:not_found)
    end
  end

  describe 'GET #new' do
    it "assigns a new user to @user" do
      get :new
      expect(assigns(:user)).to be_a_new(User)
    end

    it "renders the :new template" do
      get :new
      expect(:response).to render_template :new
    end
  end

  describe 'GET #edit' do
    it "assigns the requested user to @user" do
      get :edit, params: { id: @user }
      expect(assigns(:user)).to eq @user
    end

    it "renders the :edit template" do
      get :edit, params: { id: @user }
      expect(response).to render_template :edit
    end
  end

  describe 'POST #create' do
    context "with valid attributes" do
      it "saves the new user in the database" do
        expect{
          post :create, params: { user: attributes_for(:user) }
        }.to change(User, :count).by(1)
      end

      it "redirects to home#index" do
        post :create, params: { user: attributes_for(:user) }
        expect(response).to redirect_to(home_path)
      end

      it "give response created if create success" do
        post :create, params: { user: attributes_for(:user) }
        expect(response).to have_http_status(:found)
      end

    end

    context "with invalid attributes" do
      it "does not save the new user in the database" do
        expect{
          post :create, params: { user: attributes_for(:invalid_user) }
        }.not_to change(User, :count)
      end

      it "re-renders the :new template" do
        post :create, params: { user: attributes_for(:invalid_user) }
        expect(response).to render_template :new
      end

      it "give response bad request if create failed" do
        post :create, params: { user: attributes_for(:invalid_user) }
        expect(response).to have_http_status(:unprocessable_entity)
      end

    end
  end

  describe 'PATCH #update' do
    # before :each do
    #   @user = create(:user)
    # end

    context "with valid attributes" do
      it "locates the requested @user" do
        patch :update, params: { id: @user, user: attributes_for(:user) }
        expect(assigns(:user)).to eq @user
      end

      it "changes @user's attributes" do
        patch :update, params: { id: @user, user: attributes_for(:user, role: 2) }
        @user.reload
        expect(response).to have_http_status(:found)
        expect(@user.role).to eq(2)
      end

      it "redirects to the user" do
        patch :update, params: { id: @user, user: attributes_for(:user) }
        expect(response).to redirect_to @user
      end
    end

    context "with invalid attributes" do
      it "does not update the user in the database" do
        expect{
          patch :update, params: { id: @user, user: attributes_for(:invalid_user) }
        }.not_to change(User, :count)
        expect(response).to have_http_status(:unprocessable_entity)
      end

      it "re-renders the :edit template" do
        patch :update, params: { id: @user, user: attributes_for(:invalid_user) }
        expect(response).to render_template :edit
      end
    end
  end

  describe 'DELETE #destroy' do
    # before :each do
    #   @user = create(:user)
    # end

    it "deletes the user from the database" do
      expect{
        delete :destroy, params: { id: @user }
      }.to change(User, :count).by(-1)
      expect(response).to have_http_status(:found)
    end

    it "redirects to users#index" do
      delete :destroy, params: { id: @user }
      expect(response).to redirect_to home_path
    end
  end

end