require 'rails_helper'

describe DrawCardService do
  let!(:game) { create(:game) }
  let!(:player) { create(:player, game: game, position: 7) }

  let!(:card_2) { create(:card) }
  let!(:card_3) { create(:card) }

  let!(:game_card_2) { create(:game_card, game: game, card: card_2, order: 2) }
  let!(:game_card_3) { create(:game_card, game: game, card: card_3, order: 3) }

  describe 'chance collect card' do
    let!(:card_1) { create(:card) }
    let!(:game_card_1) { create(:game_card, game: game, card: card_1, order: 1) }

    before(:each) { DrawCardService.call(game: game, kind: Card::Kinds::CHANCE, player: player, dice: [1, 2]) }

    it { expect(player.reload.money).to eq(3005) }
    it { expect(game_card_1.reload.order).to eq(4) }
    it { expect(game.reload.game_cards.length).to eq(3) }
    it { expect(player.reload.game_cards.length).to eq(0) }
  end

  describe 'get out of jail card' do
    let!(:card_1) { create(:card, :get_out_of_jail) }
    let!(:game_card_1) { create(:game_card, game: game, card: card_1, order: 1) }

    before(:each) { DrawCardService.call(game: game, kind: Card::Kinds::CHANCE, player: player, dice: [1, 2]) }

    it { expect(player.reload.money).to eq(3000) }
    it { expect(game_card_1.reload.order).to be_nil }
    it { expect(game.reload.game_cards.active.length).to eq(2) }
    it { expect(player.reload.game_cards.length).to eq(1) }
  end

  describe 'go to jail' do
    let!(:card_1) { create(:card, :go_to_jail) }
    let!(:game_card_1) { create(:game_card, game: game, card: card_1, order: 1) }

    before(:each) { DrawCardService.call(game: game, kind: Card::Kinds::CHANCE, player: player, dice: [1, 2]) }

    it { expect(player.reload.position).to eq(card_1.amount) }
    it { expect(game_card_1.reload.order).to eq(4) }
    it { expect(game.reload.game_cards.active.length).to eq(3) }
    it { expect(player.reload.game_cards.length).to eq(0) }
  end

  describe 'move back 3 spaces' do
    let!(:card_1) { create(:card, :move_back_3_spaces) }
    let!(:game_card_1) { create(:game_card, game: game, card: card_1, order: 1) }
    let!(:chance_place) { create(:place, :chance) }
    let!(:income_tax_place) { create(:place, :income_tax) }

    before(:each) { DrawCardService.call(game: game, kind: Card::Kinds::CHANCE, player: player, dice: [1, 2]) }

    it { expect(player.reload.position).to eq(4) }
    it { expect(game_card_1.reload.order).to eq(4) }
    it { expect(game.reload.game_cards.active.length).to eq(3) }
    it { expect(player.reload.game_cards.length).to eq(0) }
  end

  describe 'move to park place' do
    let!(:card_1) { create(:card, :move_to_park_place) }
    let!(:game_card_1) { create(:game_card, game: game, card: card_1, order: 1) }
    let!(:park_place) { create(:property, :basic) }
    let!(:park_place_place) { create(:place, order: 37, property: park_place) }

    before(:each) { DrawCardService.call(game: game, kind: Card::Kinds::CHANCE, player: player, dice: [1, 2]) }

    it { expect(player.reload.position).to eq(37) }
    it { expect(game_card_1.reload.order).to eq(4) }
    it { expect(game.reload.game_cards.active.length).to eq(3) }
    it { expect(player.reload.game_cards.length).to eq(0) }
  end

  describe 'collection 25 from each players' do
    let!(:card_1) { create(:card, :collection_25_from_each_players) }
    let!(:game_card_1) { create(:game_card, game: game, card: card_1, order: 1) }

    let!(:player_2) { create(:player, game: game, position: 20) }
    let!(:player_3) { create(:player, game: game, position: 11) }

    before(:each) { DrawCardService.call(game: game, kind: Card::Kinds::CHANCE, player: player, dice: [1, 2]) }

    it { expect(player.reload.money).to eq(3050) }
    it { expect(game_card_1.reload.order).to eq(4) }
    it { expect(game.reload.game_cards.active.length).to eq(3) }
    it { expect(player.reload.game_cards.length).to eq(0) }
  end
end
