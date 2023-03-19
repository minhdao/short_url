require 'rails_helper'

RSpec.describe AuthenticationController, type: :controller do

  describe '.login' do
    let(:user) { create(:user) }

    context 'when user valid' do
      let(:params) do
        {
          username: user.username,
          password: user.password
        }
      end

      before { post :login, params: params }

      it { expect(response).to have_http_status(:ok) }
      it { expect(JSON.parse(response.body)['token']).to be_present }
    end

    context 'when user not valid' do
      let(:params) do
        {
          username: user.username,
          password: 'invalid password'
        }
      end

      before { post :login, params: params }

      it { expect(response).to have_http_status(:unauthorized) }
      it { expect(JSON.parse(response.body)['token']).not_to be_present }
    end
  end
end