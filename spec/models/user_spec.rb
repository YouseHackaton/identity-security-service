require 'rails_helper'

RSpec.describe User, type: :model do
  describe 'validations' do
    it { is_expected.to validate_presence_of(:profile_pic) }
    it { is_expected.to validate_presence_of(:id_front_side) }
    it { is_expected.to validate_presence_of(:id_back_side) }
  end
end
