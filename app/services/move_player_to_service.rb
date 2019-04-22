class MovePlayerToService < MovePlayerService
  attr_accessor :game, :player, :position, :collect_pass_go, :dice

  def initialize(game:, player:, position:, collect_pass_go: true, dice:)
    self.game = game
    self.player = player
    self.position = position
    self.collect_pass_go = collect_pass_go
    self.dice = dice
  end

  class << self
    def call(game:, player:, position:, collect_pass_go: true, dice: [])
      self.new(game: game, player: player, position: position, collect_pass_go: collect_pass_go, dice: dice).call
    end
  end

  private

  def move!
    player.money += 200 if will_pass_go? && collect_pass_go
    player.position = position
    player.save
  end

  def will_pass_go?
    player.position > position
  end
end
