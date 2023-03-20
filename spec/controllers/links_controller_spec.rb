require 'rails_helper'

RSpec.describe LinksController, type: :controller do
  before do
    user = User.create(username: 'user', email: 'user@email.com', password: '1234')
    payload = { username: user.username }
    exp = 100.hours.from_now
    token = Security::JsonWebToken.encode(payload, exp)
    request.headers['Authorization'] = token
  end


  describe '.encode' do
    context 'when url already exist' do
      let(:url) { 'http://longurl.com' }
      let(:shorter_url) { 'http://short.er/xxxxx' }
      let(:link) {create(:link, link_id: SecureRandom.uuid, url: url, shorter_url: shorter_url)}

      before { link; post :encode, params: { url: url } }
      
      it { expect(response).to have_http_status(:ok) }
      it { expect(JSON.parse(response.body)['url']).to eq(link.url) }
      it { expect(JSON.parse(response.body)['encoded']).to eq(link.shorter_url) }
    end

    context 'when url no exist' do
      let(:url) { 'http://longurlnotexist.com' }

      before { post :encode, params: { url: url } }
      
      it { expect(response).to have_http_status(:ok) }
      it { expect(JSON.parse(response.body)['url']).to eq(url) }
      it { expect(JSON.parse(response.body)['encoded']).to be_present }
    end

    context 'when url is invalid' do
      context 'with blank url' do
        before { post :encode, params: { url: '' } }

        it { expect(response).to have_http_status(:unprocessable_entity) }
        it { expect(JSON.parse(response.body)['errors'].count).to eq(1) }
        it { expect(JSON.parse(response.body)['errors']['url']).to be_present }
        it { expect(JSON.parse(response.body)['errors']['url'].join('')).to eq("can't be blank") }
      end

      context 'with wrong format url' do
        before { post :encode, params: { url: 'wrongformat' } }

        it { expect(response).to have_http_status(:unprocessable_entity) }
        it { expect(JSON.parse(response.body)['errors'].count).to eq(1) }
        it { expect(JSON.parse(response.body)['errors']['base']).to be_present }
        it { expect(JSON.parse(response.body)['errors']['base'].join('')).to eq('Url invalid format') }
      end
    end
  end

  describe '.decode' do
    context 'when url exist' do
      let(:url) { 'http://longurl.com' }
      let(:shorter_url) { 'http://short.er/xxxxx' }
      let(:link) {create(:link, link_id: SecureRandom.uuid, url: url, shorter_url: shorter_url)}

      before { link; get :decode, params: { url: shorter_url } }
      
      it { expect(response).to have_http_status(:ok) }
      it { expect(JSON.parse(response.body)['url']).to eq(link.shorter_url) }
      it { expect(JSON.parse(response.body)['decoded']).to eq(link.url) }
    end

    context 'when url exist' do
      before { get :decode, params: { url: 'https://www.notexsit.com' } }
      
      it { expect(response).to have_http_status(:not_found) }
      it { expect(JSON.parse(response.body)['errors'].count).to eq(1) }
      it { expect(JSON.parse(response.body)['errors']['base']).to be_present }
      it { expect(JSON.parse(response.body)['errors']['base']).to eq('Url not found') }
    end
  end
end