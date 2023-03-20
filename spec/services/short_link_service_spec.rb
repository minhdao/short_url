require 'rails_helper'

RSpec.describe ShortLinkService, type: :service do

  let(:time) { DateTime.current.strftime("%H%M%S%L%N") }
  let(:uuid) { SecureRandom.uuid }
  let(:url) { 'https://www.thiswebside/this/that/123/456/here/there' }

  # This is the intented hasing formula. ShortLinkService hash method must follow this formula.
  let(:hashed_result) { Digest::SHA1.hexdigest(url + uuid + time) }

  describe '.hash' do
    it { expect(described_class.hash(url, uuid, time)).to eq(hashed_result) }
  end
end