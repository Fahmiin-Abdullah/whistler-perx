require 'rails_helper'

RSpec.describe Reward, type: :model do
  describe '#associations' do
    it { should have_many(:claims) }
  end
end
