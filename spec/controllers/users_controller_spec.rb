require 'rails_helper'

RSpec.describe UsersController do
  describe 'GET #index' do
    it "populates an array of all users" do 
        user1 = create(:user, email: "tes@gmail.com")
        user2 = create(:user, email: "tes1@gmail.com")
        get :index
        expect(assigns(:users)).to match_array([user1, user2])
    end

    it "renders the :index template" do
        get :index
        expect(response).to render_template :index
    end
  end

  describe 'GET #show' do
    it "assigns the requested user to @user" do
      user = create(:user)
      get :show, params: { id: user }
      expect(assigns(:user)).to eq user
    end

    it "renders the :show template" do
      user = create(:user)
      get :show, params: { id: user }
      expect(response).to render_template :show
    end

    it "renders the not found page if request failed to load" do
        get :show, params: {id: 1}
        expect(response).to have_http_status(:not_found)
    end
  end

end