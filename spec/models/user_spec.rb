require 'rails_helper'

RSpec.describe User, type: :model do
  describe '#associations' do
    it { should have_many(:transactions) }
    it { should have_many(:points_records) }
    it { should have_many(:claims) }
    it { should have_many(:rewards).through(:claims) }
  end
end
