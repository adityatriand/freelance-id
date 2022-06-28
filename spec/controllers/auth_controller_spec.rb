require 'rails_helper'

RSpec.describe AuthController do
    describe 'POST #login' do
        before :each do
            @user = User.create(email: 'tes@gmail.com', password: '12345678', role: 1)
        end
        context 'with valid user' do
            it 'get success when email and password right' do
                email = 'tes@gmail.com'
                password = '12345678'
                post :login, params: {email: email, password: password}
                expect(response).to have_http_status(:found)
            end

            it '[JSON] get success when email and password right' do
                request.accept = "application/json"
                email = 'tes@gmail.com'
                password = '12345678'
                post :login, params: {email: email, password: password}
                expect(response).to have_http_status(:ok)
            end

            it 'get fail when password not right' do
                email = 'tes@gmail.com'
                password = '123456789'
                post :login, params: {email: email, password: password}
                expect(response).to have_http_status(:found)
            end

            it '[JSON] get fail when password not right' do
                request.accept = "application/json"
                email = 'tes@gmail.com'
                password = '123456789'
                post :login, params: {email: email, password: password}
                expect(response).to have_http_status(:unauthorized)
            end
        end

        context 'with invalid user' do
            it 'unknown if use email not registered yet' do
                email = 'tes1@gmail.com'
                password = '123456789'
                post :login, params: {email: email, password: password}
                expect(response).to have_http_status(:found)
            end

            it '[JSON]  unknown if use email not registered yet' do
                request.accept = "application/json"
                email = 'tes1@gmail.com'
                password = '123456789'
                post :login, params: {email: email, password: password}
                expect(response).to have_http_status(:unauthorized)
            end
        end

    end

    describe 'DELETE #logout' do
        before :each do
            @user = User.create(email: 'tes@gmail.com', password: '12345678', role: 1)
            email = 'tes@gmail.com'
            password = '12345678'
            post :login, params: {email: email, password: password}
            if response.status == 200
                session[:user_id] = User.select(:id).where(email: email)
            end
        end
        it 'will set session user_id nill' do
            delete :logout, params: {id: session[:user_id]}
            expect(response).to have_http_status(:found)
        end

        it '[JSON] will set session user_id nill' do
            request.accept = "application/json"
            delete :logout, params: {id: session[:user_id]}
            expect(response).to have_http_status(:ok)
        end
    end
end