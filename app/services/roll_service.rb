class RollService
  attr_accessor :game, :player, :errors

  def initialize(game:, player:)
    self.game = game
    self.player = player
    self.errors =  ActiveModel::Errors.new(self)
  end

  def call
    move!

    unless rolled_doubles?
      return self if player.reload.current_place_purchasable?
      game.next_player! and return self
    end

    increment_player_number_of_doubles
    if rolled_3_doubles?
      player.update(in_jail: true, position: 10, number_of_doubles: 0)
      game.next_player!
    else
      player.save
    end

    self
  end

  def dice
    @dice ||= [rand(6) + 1, rand(6) + 1]
  end

  class << self
    def call(game:, player:)
      self.new(game: game, player: player).call
    end
  end

  private

  def move!
    MovePlayerService.call(game: game, player: player, dice: dice)
  end

  def spaces
    dice.reduce(:+)
  end

  def rolled_doubles?
    dice.first == dice.last
  end

  def increment_player_number_of_doubles
    player.increment(:number_of_doubles)
  end

  def rolled_3_doubles?
    player.number_of_doubles >= 3
  end
end
