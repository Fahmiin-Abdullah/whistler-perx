require 'rails_helper'

RSpec.describe User, type: :model do
  describe '#associations' do
    it { should have_many(:transactions) }
    it { should have_many(:points_records) }
  end
end
