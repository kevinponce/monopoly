class MovePlayerService
  attr_accessor :game, :player, :spaces, :collect_pass_go, :dice

  def initialize(game:, player:, spaces: nil, collect_pass_go: true, dice: [])
    self.game = game
    self.player = player
    self.spaces = spaces || dice.reduce(:+)
    self.collect_pass_go = collect_pass_go
    self.dice = dice
  end

  def call
    move!

    draw_chance_card! and return self if place.chance?
    draw_community_chest_card! and return self if place.community_chest?
    property_action! and return self if place.property?
    go_to_jail! and return self if place.go_to_jail?
    free_parking! and return self if place.free_parking?

    income_tax! and return self if place.income_tax?
    luxury_tax! and return self if place.luxury_tax?

    self
  end

  class << self
    def call(game:, player:, spaces: nil, collect_pass_go: true, dice: [])
      self.new(game: game, player: player, spaces: spaces, collect_pass_go: collect_pass_go, dice: dice).call
    end
  end

  private

  def move!
    player.position += spaces

    if player.position >= 40
      player.position -= 40
      player.money += 200 if collect_pass_go
    elsif player.position < 0
      player.position -= 40
    end

    player.save
  end

  def place
    @place ||= Place.find_by(order: player.position)
  end

  def draw_chance_card!
    DrawCardService.call(game: game, kind: Card::Kinds::CHANCE, player: player, dice: dice)
  end

  def draw_community_chest_card!
    DrawCardService.call(game: game, kind: Card::Kinds::COMMUNITY_CHEST, player: player, dice: dice)
  end

  def property
    place.property
  end

  def player_property
    @player_property ||= game.player_properties.find_by(property: place.property)
  end

  def property_owner
    @property_owner ||= player_property.try(:player)
  end

  def property_action!
    return unless property_owner
    return if property_owner.id == player.id # owned by user

    amount = CalculatePropertyRentService.call(player_property, dice)

    player.decrement!(:money, amount)
    property_owner.increment!(:money, amount)
  end

  def go_to_jail!
    jail_position = Place.find_by(kind: Place::Kinds::JAIL).order
    MovePlayerToService.call(game: game, player: player, position: jail_position, collect_pass_go: false, dice: dice)
    player.update(in_jail: true)
  end

  def free_parking!
    player.increment!(:money, game.jackpot)
    game.reset_jackpot!
  end

  def income_tax!
    player.decrement!(:money, Place::INCOME_TAX_AMOUNT)
    game.increment!(:jackpot, Place::INCOME_TAX_AMOUNT)
  end

  def luxury_tax!
    player.decrement!(:money, Place::LUXURY_TAX_AMOUNT)
    game.increment!(:jackpot, Place::LUXURY_TAX_AMOUNT)
  end
end
