require 'rails_helper'

describe StartGameService do
  before(:each) { srand(67809) }

  let!(:game) { create(:game) }
  let!(:player_1) { create(:player, game: game) }
  let!(:player_2) { create(:player, game: game) }
  let!(:player_3) { create(:player, game: game) }
  let!(:player_4) { create(:player, game: game) }

  let!(:card_1) { create(:card) }
  let!(:card_2) { create(:card) }
  let!(:card_3) { create(:card, :community_chest) }

  let!(:game_card_1) { create(:game_card, game: game, card: card_1, order: 1) }
  let!(:game_card_2) { create(:game_card, game: game, card: card_2, order: 2) }
  let!(:game_card_3) { create(:game_card, game: game, card: card_3, order: 3) }

  before(:each) { StartGameService.call(game) }

  it { expect(player_1.reload.money).to eq(3000) }
  it { expect(player_2.reload.money).to eq(3000) }
  it { expect(player_3.reload.money).to eq(3000) }
  it { expect(player_4.reload.money).to eq(3000) }

  it { expect(game.reload.jackpot).to eq(Game::INIT_JACKPOT) }
  it { expect(game.reload.game_cards).to_not be_empty }
  it { expect(game.reload.game_cards.chance).to_not be_empty }
  it { expect(game.reload.game_cards.community_chest).to_not be_empty }
  it { expect(game.reload.status).to eq(Game::Statuses::STARTED) }
end
