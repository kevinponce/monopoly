json.game do
  json.id      @game.id
  json.title   @game.title
  json.jackpot @game.jackpot
  json.status  @game.status
  json.turn    @game.turn

  json.players(@game.players) do |player|
    json.partial! 'api/games/players/player', player: player
  end

  json.current_player_turn do
    json.partial! 'api/games/players/player', player: @game.current_player if @game.current_player
  end
end
