require 'rails_helper'

RSpec.describe User, type: :model do
  describe 'validations' do
    it { is_expected.to validate_presence_of(:selfie) }
    it { is_expected.to validate_presence_of(:document_front_side) }
    it { is_expected.to validate_presence_of(:document_back_side) }
  end
end
