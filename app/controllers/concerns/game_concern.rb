# frozen_string_literal: true

module GameConcern
  extend ActiveSupport::Concern

  private

  def fetch_player
    @player = @game.players.find_by(user_id: current_user.id)
    render status: 422, json: { message: 'Player not found' } unless @player
  end

  def players_turn?
    return if @player == @game.current_player

    render status: 422, json: { message: 'I am sorry it is not your turn' }
  end
end
