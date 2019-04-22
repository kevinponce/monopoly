class CalculatePropertyRentService
  attr_accessor :player_property, :dice

  def initialize(player_property, dice)
    self.player_property = player_property
    self.dice = dice
  end

  def call
    return 0 if player_property.mortgaged
    return calc_rail_road_rent if property.rail_road?
    return calc_utility_rent if property.utility?
    return calc_hotel_rent if player_property.hotel?
    return calc_house_rent if player_property.house?
    return monopoly_rent if player_property.monopoly?

    basic_rent
  end

  class << self
    def call(player_property, dice)
      self.new(player_property, dice).call
    end
  end

  private

  def calc_rail_road_rent
    player_property.grouped_properties_own_by_user_count * property.rent
  end

  def calc_utility_rent
    if player_property.monopoly?
      dice.reduce(:+) * 10
    else
      dice.first * 3
    end
  end

  def calc_hotel_rent
    property.hotel_rent
  end

  def calc_house_rent
    property.send("house_rent_#{player_property.house_count}")
  end

  def property
    player_property.property
  end

  def monopoly_rent
    property.monopoly_rent
  end

  def basic_rent
    property.rent
  end
end
