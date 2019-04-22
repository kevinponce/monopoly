class Api::Games::PlayersController < Api::GamesController
  before_action :fetch_game
  before_action :game_already_started?, only: [:create]

  def create
    player = @game.players.new(user_id: current_user.id, name: current_user.name)

    unless player.save
      render status: 422, json: { message: player.errors.full_messages.to_sentence }
      return
    end

    @game.reload
    render 'api/games/show'
  end

  private

  def game_already_started?
    return unless @game.started?
    render status: 422, json: { message: 'I am sorry the game already started' }
  end
end
