require 'rails_helper'

RSpec.describe LinkService, type: :service do

  subject(:service) { described_class.new (params) }

  describe '.shorten' do
    context 'with valid url' do
      let(:url) { 'http://longurl.com/this/that' }
      let(:params) { { url: url} }
      let(:link) { Link.find_by(url: url) }

      before { service.shorten }

      it { expect(service.valid?).to be_truthy }
      it { expect(service.errors).not_to be_present }
      it { expect(service.results[:url]).to be_present }
      it { expect(service.results[:url]).to eq(url) }
      it { expect(service.results[:shorter_url]).to be_present }
      it { expect(service.results[:shorter_url]).to eq(link.shorter_url) }
    end 

    context 'with invalid url' do
      let(:url) { 'invalidurl' }
      let(:params) { { url: url} }

      before { service.shorten }

      it { expect(service.invalid?).to be_truthy }
      it { expect(service.errors).to be_present }
      it { expect(service.errors.messages[:base].count).to eq(1) }
      it { expect(service.errors.messages[:base].first).to eq('Url invalid format') }
    end
  end
end