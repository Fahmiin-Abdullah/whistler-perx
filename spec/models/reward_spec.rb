require 'rails_helper'

RSpec.describe Reward, type: :model do
  it { should have_many(:claims) }
end
