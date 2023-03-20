require 'rails_helper'

RSpec.describe UsersController, type: :controller do

  describe '.create' do

    context 'when valid params' do
      before { post :create, params: params }

      let(:params) do
        {
          username: 'johndoe',
          email: 'johndoe@email.com',
          password: '123456'
        }
      end
      
      it { expect(response).to have_http_status(:created) }
      it { expect(JSON.parse(response.body)['username']).to eq(params[:username]) }
      it { expect(JSON.parse(response.body)['email']).to eq(params[:email]) }
      it { expect(JSON.parse(response.body)['password']).to eq(nil) }
      it { expect(JSON.parse(response.body)['created_at']).to be_present }
      it { expect(JSON.parse(response.body)['updated_at']).to be_present }
    end

    context 'when invalid params' do
      context 'with invalid email' do
        before { post :create, params: params }

        let(:params) do
          {
            username: 'johndoe',
            email: 'johndoe.com',
            password: '123456'
          }
        end

        it { expect(response).to have_http_status(:unprocessable_entity) }
        it { expect(JSON.parse(response.body)['errors'].count).to eq(1) }
        it { expect(JSON.parse(response.body)['errors']['email'].join('')).to eq('is invalid') }
      end

      context 'with invalid password' do
        before { post :create, params: params }

        let(:params) do
          {
            username: 'johndoe',
            email: 'johndoe@gmail.com',
            password: '123'
          }
        end

        it { expect(response).to have_http_status(:unprocessable_entity) }
        it { expect(JSON.parse(response.body)['errors'].count).to eq(1) }
        it { expect(JSON.parse(response.body)['errors']['password'].join('')).to eq('is too short (minimum is 4 characters)') }
      end

      context 'with missing a required params' do
        before { post :create, params: params }

        let(:params) do
          {
            username: '',
            email: 'johndoe@gmail.com',
            password: '12345'
          }
        end

        it { expect(response).to have_http_status(:unprocessable_entity) }
        it { expect(JSON.parse(response.body)['errors'].count).to eq(1) }
        it { expect(JSON.parse(response.body)['errors']['username'].join('')).to eq("can't be blank") }
      end
    end

    context 'when duplicated users found' do
      context 'with username' do
        let!(:existing_user) { create(:user, username: 'johndoe') }

        before { post :create, params: params }

        let(:params) do
          {
            username: 'johndoe',
            email: 'johndoe@gmail.com',
            password: '12345'
          }
        end

        it { expect(response).to have_http_status(:unprocessable_entity) }
        it { expect(JSON.parse(response.body)['errors'].count).to eq(1) }
        it { expect(JSON.parse(response.body)['errors']['username'].join('')).to eq("has already been taken") }
      end

      context 'with email' do
        let!(:existing_user) { create(:user, email: 'johndoe@gmail.com') }

        before { post :create, params: params }

        let(:params) do
          {
            username: 'johndoe',
            email: 'johndoe@gmail.com',
            password: '12345'
          }
        end

        it { expect(response).to have_http_status(:unprocessable_entity) }
        it { expect(JSON.parse(response.body)['errors'].count).to eq(1) }
        it { expect(JSON.parse(response.body)['errors']['email'].join('')).to eq("has already been taken") }
      end
    end
  end
end