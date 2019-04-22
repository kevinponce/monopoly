class StartGameService
  attr_accessor :game, :errors

  def initialize(game)
    self.game = game
    self.errors =  ActiveModel::Errors.new(self)
  end

  def call
    assign_player_order!
    shuffle_chance_cards!
    shuffle_community_chest_cards!
    game.start!

    self
  end

  class << self
    def call(game)
      self.new(game).call
    end
  end

  private

  def assign_player_order!
    ShuffleService.call(game.players)
  end

  def build_chance_cards
    Card.chance.reduce([]) do |cards, card|
      cards << game.game_cards.new(card: card)
      cards
    end
  end

  def shuffle_chance_cards!
    ShuffleService.call(build_chance_cards)
  end

  def build_community_chest_cards
    Card.community_chest.reduce([]) do |cards, card|
      cards << game.game_cards.new(card: card)
      cards
    end
  end

  def shuffle_community_chest_cards!
    ShuffleService.call(build_community_chest_cards)
  end
end
