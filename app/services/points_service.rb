class PointsService
  # ==============================================================================
  # All methods related to points
  # Currently online housing points calculator
  # ==============================================================================
  def initialize(currency, amount)
    @currency = currency
    @amount = amount.to_f
  end

  def calculate_points
    standard_points = (@amount / 100).floor * 10
    return standard_points if @currency.upcase == 'SGD'

    standard_points * 2
  end
end
