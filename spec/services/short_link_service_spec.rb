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

  describe '.slice' do
    let(:starting) { 0 }
    let(:ending) { 6 }

    # This is the intented result for slicing a hashed string. ShortLinkSevice slice method must follow this result.
    let(:slice_result) { hashed_result[starting..ending] }

    it { expect(described_class.slice(hashed_result, starting, ending)).to eq(slice_result) }
  end
end