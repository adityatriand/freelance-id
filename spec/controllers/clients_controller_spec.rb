require 'rails_helper'

RSpec.describe ClientsController do
  let(:user){
    FactoryBot.create(:user, role: 2)
  }
  subject(:client){
    FactoryBot.create(:client, user: user)
  }
  describe 'GET #index' do
      it "populates an array of all clients" do
          client1 = create(:client, phone: "089612345678", user: user)
          client2 = create(:client, phone: "089612345679", user: user)
          get :index
          expect(assigns(:clients)).to match_array([client1, client2])
      end

      it "renders the :index template" do
          get :index
          expect(response).to render_template :index
      end
  end

  describe 'GET #show' do
    it "assigns the requested client to @client" do
      get :show, params: { id: client }
      expect(assigns(:client)).to eq client
    end

    it "renders the :show template" do
      get :show, params: { id: client }
      expect(response).to render_template :show
    end

    it "renders the not found page if request failed to load" do
        get :show, params: {id: 1}
        expect(response).to have_http_status(:not_found)
    end
  end

  describe 'GET #new' do
    it "assigns a new client to @client" do
      get :new
      expect(assigns(:client)).to be_a_new(Client)
    end

    it "renders the :new template" do
      get :new
      expect(:response).to render_template :new
    end
  end

  describe 'GET #edit' do
    it "assigns the requested client to @client" do
      get :edit, params: { id: client }
      expect(assigns(:client)).to eq client
    end

    it "renders the :edit template" do
      get :edit, params: { id: client }
      expect(response).to render_template :edit
    end
  end

  describe 'POST #create' do
    context "with valid attributes" do
      it "saves the new client in the database" do
        expect{
          post :create, params: { client: attributes_for(:client, user_id: user.id) }
        }.to change(Client, :count).by(1)
      end

      it "redirects to clients#show" do
        post :create, params: { client: attributes_for(:client, user_id: user.id)}
        expect(response).to redirect_to(client_path(assigns[:client]))
      end

      it "give response created if create success" do
        post :create, params: { client: attributes_for(:client, user_id: user.id)}
        expect(response).to have_http_status(:found)
      end

    end

    context "with invalid attributes" do
      it "does not save the new client in the database" do
        expect{
          post :create, params: { client: attributes_for(:invalid_client, user_id: user.id) }
        }.not_to change(Client, :count)
      end

      it "re-renders the :new template" do
        post :create, params: { client: attributes_for(:invalid_client, user_id: user.id) }
        expect(response).to render_template :new
      end

      it "give response bad request if create failed" do
        post :create, params: { client: attributes_for(:invalid_client, user_id: user.id) }
        expect(response).to have_http_status(:unprocessable_entity)
      end

    end
  end

  describe 'PATCH #update' do
    before :each do
      @client = create(:client, user: user)
    end

    context "with valid attributes" do
      it "locates the requested @client" do
        patch :update, params: { id: @client, client: attributes_for(:client) }
        expect(assigns(:client)).to eq @client
      end

      it "changes @client's attributes" do
        patch :update, params: { id: @client, client: attributes_for(:client) }
        @client.reload
        expect(response).to have_http_status(:found)
      end

      it "redirects to the client" do
        patch :update, params: { id: @client, client: attributes_for(:client) }
        expect(response).to redirect_to @client
      end
    end

    context "with invalid attributes" do
      it "does not update the client in the database" do
        expect{
          patch :update, params: { id: @client, client: attributes_for(:invalid_client) }
        }.not_to change(Client, :count)
        expect(response).to have_http_status(:unprocessable_entity)
      end

      it "re-renders the :edit template" do
        patch :update, params: { id: @client, client: attributes_for(:invalid_client) }
        expect(response).to render_template :edit
      end
    end
  end

  describe 'DELETE #destroy' do
    before :each do
      @client = create(:client, user: user)
    end

    it "deletes the client from the database" do
      expect{
        delete :destroy, params: { id: @client }
      }.to change(Client, :count).by(-1)
      expect(response).to have_http_status(:found)
    end

    it "redirects to clients#index" do
      delete :destroy, params: { id: @client }
      expect(response).to redirect_to clients_url
    end
  end
end