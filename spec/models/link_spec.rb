require 'rails_helper'

RSpec.describe Link, type: :model do
  subject { create(:link) }  

  it { is_expected.to validate_presence_of(:link_id) }

  it { is_expected.to validate_presence_of(:url) }
  it { is_expected.to validate_uniqueness_of(:url) }

  it { is_expected.to validate_presence_of(:click_count) }
  it { is_expected.to validate_numericality_of(:click_count).is_greater_than(-1).only_integer }
end
