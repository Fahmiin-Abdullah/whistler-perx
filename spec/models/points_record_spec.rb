require 'rails_helper'

RSpec.describe PointsRecord, type: :model do
  describe '#associations' do
    it { should belong_to(:user) }
    it { should belong_to(:transaction_record) }
  end
end
