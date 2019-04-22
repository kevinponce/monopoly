class DrawCardService
  attr_accessor :game, :kind, :player, :dice, :errors

  def initialize(game:, kind:, player:, dice:)
    self.game = game
    self.kind = kind
    self.player = player
    self.dice = dice
    self.errors =  ActiveModel::Errors.new(self)
  end

  def call
    invalid_kind and return self unless Card::Kinds::ALL.include? kind

    if card.action == Card::Actions::GET_OUT_OF_JAIL
      game_card.update(order: nil, player: player)
      return self
    elsif card.action == Card::Actions::GO_TO_JAIL
      player.update(in_jail: true, position: card.amount)
    elsif card.action == Card::Actions::ADVANCE_TO
      MovePlayerToService.call(game: game, player: player, position: card.amount, dice: dice)
    elsif card.action == Card::Actions::MOVE
      MovePlayerService.call(game: game, player: player, spaces: card.amount, dice: dice)
    elsif card.action == Card::Actions::COLLECT
      player.increment!(:money, card.amount)
    elsif card.action == Card::Actions::COLLECT_FROM_EACH_PLAYERS
      collect_from_each_player!
    end

    add_card_to_bottom!

    self
  end

  class << self
    def call(game:, kind:, player:, dice:)
      self.new(game: game, kind: kind, player: player, dice: dice).call
    end
  end

  def game_cards
    game.game_cards.send(kind).active.order(:order)
  end

  def game_card
    @game_card ||= game_cards.first
  end

  def card
    @card ||= game_card.card
  end

  private

  def add_card_to_bottom!
    game_card.update(order: new_card_order)
    if new_card_order > 10000
      # shuffle and resets the order numbers
      ShuffleService.call(game_cards)
    end
  end

  def new_card_order
    game_cards.last.order + 1
  end

  def invalid_kind
    self.errors.add(:base, "Invalid kind: #{kind}")
  end

  def collect_from_each_player!
    player.increment!(:money, card.amount * (game.players.length - 1))

    game.players.where.not(id: player.id).each do |other_player|
      other_player.decrement!(:money, card.amount)
    end
  end
end
