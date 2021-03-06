require 'rails_helper'

RSpec.describe Transaction, type: :model do
  describe '#associations' do
    it { should belong_to(:user) }
    it { should have_many(:points_records) }
  end
end
