class Api::Games::StartController < Api::GamesController
  before_action :fetch_game
  before_action :game_already_started?

  def create
    sgs = StartGameService.call(@game)

    if sgs.errors.present?
      render status: 422, json: { message: sgs.errors.full_messages.to_sentence }
      return
    end

    @game.reload
    render 'api/games/show'
  end

  private

  def game_already_started?
    return unless @game.started?
    render status: 422, json: { message: 'Game already started' }
  end
end
