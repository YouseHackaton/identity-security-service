require 'rails_helper'

RSpec.describe RequestLog, type: :model do
  describe 'validations' do
    it { is_expected.to validate_presence_of(:request_type) }
  end

  describe 'ActiveModel associations' do
    it { should belong_to(:user) }
  end
end
