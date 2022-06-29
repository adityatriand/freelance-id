require 'rails_helper'

RSpec.describe PortofoliosController do
  before :each do
    @user = User.create(email: 'tes@gmail.com', password: '12345678', role: 1)
    @freelancer = FactoryBot.create(:freelancer, user: @user)
    session[:user_id] = @user.id
    session[:role] = @user.role
    allow(controller).to receive(:current_user) { @freelancer }
    @portofolio = FactoryBot.create(:portofolio, type_project: 'client', user: @user)
  end

  describe 'GET #index' do
    it "populates an array of all portofolio by user id" do
        portofolio1 = create(:portofolio, type_project: 'client', user: @user)
        get :index, params: {id_user: @user.id}
        expect(assigns(:portofolios)).to match_array([@portofolio, portofolio1])
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
    it "assigns the requested portofolio to @portofolio" do
      get :show, params: { id: @portofolio }
      expect(assigns(:portofolio)).to eq @portofolio
    end

    it "renders the :show template" do
      get :show, params: { id: @portofolio }
      expect(response).to render_template :show
    end

    it "renders the not found page if request failed to load" do
        get :show, params: {id: 10}
        expect(response).to have_http_status(:not_found)
    end
  end
  describe 'GET #new' do
    it "assigns a new portofolio to @portofolio" do
      get :new
      expect(assigns(:portofolio)).to be_a_new(Portofolio)
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
    it "assigns the requested freelancer to @freelancer" do
      get :edit, params: { id: @portofolio }
      expect(assigns(:portofolio)).to eq @portofolio
    end

    it "renders the :edit template" do
      get :edit, params: { id: @portofolio }
      expect(response).to render_template :edit
    end
  end
  describe 'POST #create' do
    context "with valid attributes" do
      it "saves the new portofolio in the database" do
        expect{
          post :create, params: { portofolio: attributes_for(:portofolio, type_project: 'client', user_id: @user.id) }
        }.to change(Portofolio, :count).by(1)
      end

      it "redirects to portofolio#show" do
        post :create, params: { portofolio: attributes_for(:portofolio, type_project: 'client', user_id: @user.id)}
        expect(response).to redirect_to(portofolio_path(assigns[:portofolio]))
      end

      it "[JSON] give response found if create success" do
        request.accept = "application/json"
        post :create, params: { portofolio: attributes_for(:portofolio, type_project: 'client', user_id: @user.id)}
        expect(response).to have_http_status(:created)
      end
    end

    context "with invalid attributes" do
      it "does not save the new portofolio in the database" do
        expect{
          post :create, params: { portofolio: attributes_for(:invalid_portofolio, user_id: @user.id) }
        }.not_to change(Portofolio, :count)
      end

      it "re-renders the :new template" do
        post :create, params: { portofolio: attributes_for(:invalid_portofolio, user_id: @user.id) }
        expect(response).to render_template :new
      end

      it "[JSON] give response bad request if create failed" do
        request.accept = "application/json"
        post :create, params: { portofolio: attributes_for(:invalid_portofolio, user_id: @user.id) }
        expect(response).to have_http_status(:unprocessable_entity)
      end
    end

  end

  describe 'PATCH #update' do
    context "with valid attributes" do
      it "locates the requested @portofolio" do
        patch :update, params: { id: @portofolio, portofolio: attributes_for(:portofolio, type_project:'personal') }
        expect(assigns(:portofolio)).to eq @portofolio
      end

      it "changes @portofolio's attributes" do
        patch :update, params: { id: @portofolio, portofolio: attributes_for(:portofolio, type_project:'personal') }
        @portofolio.reload
        expect(response).to have_http_status(:found)
      end

      it "redirects to the portofolio" do
        patch :update, params: { id: @portofolio, portofolio: attributes_for(:portofolio, type_project:'personal') }
        expect(response).to redirect_to @portofolio
      end
    end

    context "with invalid attributes" do
      it "does not update the portofolio in the database" do
        expect{
          patch :update, params: { id: @portofolio, portofolio: attributes_for(:invalid_portofolio) }
        }.not_to change(Portofolio, :count)
        expect(response).to have_http_status(:unprocessable_entity)
      end

      it "re-renders the :edit template" do
        patch :update, params: { id: @portofolio, portofolio: attributes_for(:invalid_portofolio) }
        expect(response).to render_template :edit
      end
    end
  end

  describe 'DELETE #destroy' do

    it "deletes the portofolio from the database" do
      expect{
        delete :destroy, params: { id: @portofolio }
      }.to change(Portofolio, :count).by(-1)
      expect(response).to have_http_status(:found)
    end

    it "redirects to portofolios#index" do
      delete :destroy, params: { id: @portofolio }
      expect(response).to redirect_to "/portofolios?id_user=#{@user.id}"
    end
  end

end