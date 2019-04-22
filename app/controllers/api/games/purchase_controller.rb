class Api::Games::PurchaseController < Api::GamesController
  include GameConcern

  before_action :fetch_game
  before_action :verify_game_started?
  before_action :fetch_player
  before_action :players_turn?

  def create
    if purcahse?
      ps = PurchaseService.call(game: @game, player: @player)
      if ps.errors.present?
        render status: 422, json: { message: ps.errors.full_messages.to_sentence }
        return
      end
    end

    @game.next_player!

    @game.reload
    render 'api/games/show'
  end

  private

  def purcahse?
    params.fetch(:purcahse, '0') == '1'
  end
end
