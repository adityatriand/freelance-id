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
end