class Api::Games::RollController < Api::GamesController
  include GameConcern

  before_action :fetch_game
  before_action :verify_game_started?
  before_action :fetch_player
  before_action :players_turn?

  def create
    roll_service = RollService.call(game: @game, player: @player)
    if roll_service.errors.present?
      render status: 422, json: { message: roll_service.errors.full_messages.to_sentence }
    end

    @game.reload
    render 'api/games/show'
  end
end
