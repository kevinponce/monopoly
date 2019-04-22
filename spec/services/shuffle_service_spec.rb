require 'rails_helper'

describe ShuffleService do
  before(:each) { srand(67809) }

  describe 'shuffle cards' do
    let!(:game) { create(:game) }
    let!(:game_card_1) { create(:game_card, game: game, order: 1) }
    let!(:game_card_2) { create(:game_card, game: game, order: 2) }
    let!(:game_card_3) { create(:game_card, game: game, order: 3) }
    let!(:orginal_card_order) { [game_card_1.id, game_card_2.id, game_card_3.id] }

    before(:each) { ShuffleService.call(game.reload.game_cards).length }

    it { expect(game.reload.game_cards.order(:order).ids).to_not eq(orginal_card_order) }
  end
end
