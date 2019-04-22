class Api::GamesController < ApplicationController
  before_action :authenticate_user!

  def create
    @game = Game.new(game_params)

    unless @game.save
      render status: 422, json: { message: @game.errors.full_messages.to_sentence }
      return
    end

    @game.players.create(user_id: current_user.id, name: current_user.name)

    @game.reload

    render 'api/games/show'
  end

  private

  def game_params
    params.required(:game).permit(:title)
  end

  def game_id
    params.fetch(:game_id, nil)
  end

  def fetch_game
    @game = Game.find_by(id: game_id)
    render status: 404, json: { message: 'Game not found' } unless @game
  end

  def verify_game_started?
    return if @game.started?
    render status: 422, json: { message: 'Game has not started yet' }
  end
end
