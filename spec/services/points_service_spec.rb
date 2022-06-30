require 'rails_helper'

RSpec.describe PointsService, type: :service do
  describe '::calculate_points' do
    it 'awards 10 points for every $100' do
      expect(PointsService.new('SGD', 540).calculate_points).to eq(50)
    end

    context 'when SGD' do
      it 'returns standard points' do
        expect(PointsService.new('SGD', 100).calculate_points).to eq(10)
      end
    end

    context 'when foreign' do
      it 'returns double points' do
        expect(PointsService.new('BND', 100).calculate_points).to eq(20)
      end
    end
  end
end
