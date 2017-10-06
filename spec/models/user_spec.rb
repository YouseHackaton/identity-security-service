require 'rails_helper'

RSpec.describe User, type: :model do
  describe 'ActiveModel associations' do
    it { should have_many(:request_logs) }
  end
end
