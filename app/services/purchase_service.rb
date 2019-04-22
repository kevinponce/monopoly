class PurchaseService
  attr_accessor :game, :player, :errors

  def initialize(game:, player:)
    self.game = game
    self.player = player
    self.errors =  ActiveModel::Errors.new(self)
  end

  def call
    unless current_place_purchasable?
      not_purcahsable_error
      return self
    end

    unless enough_money?
      not_enough_money
      return self
    end

    player_property = game.player_properties.new(player_id: player.id, property: property)
    if player_property.save
      player.decrement!(:money, property.price)
    else
      self.errors.add(:base, player_property.errors.full_messages.to_sentence)
    end

    self
  end

  class << self
    def call(game:, player:)
      self.new(game: game, player: player).call
    end
  end

  private

  def current_place_purchasable?
    player.current_place_purchasable?
  end

  def not_purcahsable_error
    self.errors.add(:base, 'I am sorry this is not purchasable')
  end

  def property
    @property ||= player.current_property
  end

  def enough_money?
    property.price <= player.money
  end

  def not_enough_money
    self.errors.add(:base, 'I am sorry you do not have enough money')
  end
end
