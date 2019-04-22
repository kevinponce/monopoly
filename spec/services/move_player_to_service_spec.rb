require 'rails_helper'

describe MovePlayerToService do
  let!(:game) { create(:game) }

  describe 'visiting jail' do
    let!(:player) { create(:player, game: game, position: 7) }
    let!(:jail) { create(:place, :jail) }

    before(:each) { MovePlayerToService.call(game: game, player: player, dice: [1, 2], position: 10) }

    it { expect(player.reload.position).to eq(10) }
  end

  describe 'chance' do
    let!(:player) { create(:player, game: game, position: 0) }
    let!(:chance) { create(:place, :chance) }
    let!(:card_1) { create(:card) }
    let!(:card_2) { create(:card) }
    let!(:card_3) { create(:card) }
    let!(:game_card_1) { create(:game_card, game: game, card: card_1, order: 1) }
    let!(:game_card_2) { create(:game_card, game: game, card: card_2, order: 2) }
    let!(:game_card_3) { create(:game_card, game: game, card: card_3, order: 3) }

    before(:each) { MovePlayerToService.call(game: game, player: player, dice: [4, 3], position: chance.order) }

    it { expect(player.reload.money).to eq(3005) }
    it { expect(game_card_1.reload.order).to eq(4) }
    it { expect(game.reload.game_cards.length).to eq(3) }
    it { expect(player.reload.game_cards.length).to eq(0) }
    it { expect(player.reload.position).to eq(chance.order) }
  end

  describe 'passed go community_chest get of jail' do
    let!(:player) { create(:player, game: game, position: 30) }
    let!(:community_chest) { create(:place, :community_chest) }
    let!(:card_1) { create(:card, :get_out_of_jail, :community_chest) }
    let!(:card_2) { create(:card, :community_chest) }
    let!(:card_3) { create(:card, :community_chest) }
    let!(:game_card_1) { create(:game_card, game: game, card: card_1, order: 1) }
    let!(:game_card_2) { create(:game_card, game: game, card: card_2, order: 2) }
    let!(:game_card_3) { create(:game_card, game: game, card: card_3, order: 3) }

    before(:each) { MovePlayerToService.call(game: game, player: player, dice: [6, 6], position: community_chest.order) }

    it { expect(player.reload.money).to eq(3200) }
    it { expect(game_card_1.reload.order).to eq(nil) }
    it { expect(game.reload.game_cards.active.length).to eq(2) }
    it { expect(player.reload.game_cards.length).to eq(1) }
    it { expect(player.reload.position).to eq(community_chest.order) }
  end

  describe 'property not owned' do
    let!(:player) { create(:player, game: game, position: 30) }
    let!(:player_2) { create(:player, game: game, position: 11) }

    let!(:park_place_property) { create(:property, :basic) }
    let!(:park_place) { create(:place, :park_place, property: park_place_property) }

    before(:each) { MovePlayerToService.call(game: game, player: player, dice: [6, 1], position: park_place.order) }

    it { expect(player.reload.money).to eq(3000) }
    it { expect(player.reload.position).to eq(park_place.order) }
    it { expect(player_2.reload.money).to eq(3000) }
  end

  describe 'property owned by other player' do
    let!(:player) { create(:player, game: game, position: 30) }
    let!(:player_2) { create(:player, game: game, position: 11) }

    let!(:property_group) { create(:property_group) }
    let!(:park_place_property) { create(:property, :basic, property_group: property_group) }
    let!(:boardwalk_property) { create(:property, :basic, property_group: property_group) }
    let!(:park_place) { create(:place, :park_place, property: park_place_property) }
    let!(:player_property) { create(:player_property, game: game, player: player_2, property: park_place_property) }

    before(:each) { MovePlayerToService.call(game: game, player: player, dice: [6, 1], position: park_place.order) }

    it { expect(player.reload.money).to eq(2965) }
    it { expect(player.reload.position).to eq(park_place.order) }
    it { expect(player_2.reload.money).to eq(3035) }
  end

  describe 'free parking' do
    let!(:player) { create(:player, game: game, position: 18) }

    let!(:free_parking) { create(:place, :free_parking) }

    before(:each) { MovePlayerToService.call(game: game, player: player, dice: [1, 1], position: free_parking.order) }

    it { expect(player.reload.money).to eq(3500) }
    it { expect(player.reload.position).to eq(free_parking.order) }
  end

  describe 'income_tax' do
    let!(:player) { create(:player, game: game, position: 0) }

    let!(:income_tax) { create(:place, :income_tax) }

    before(:each) { MovePlayerToService.call(game: game, player: player, dice: [2, 2], position: income_tax.order) }

    it { expect(player.reload.money).to eq(3000 - Place::INCOME_TAX_AMOUNT) }
    it { expect(player.reload.position).to eq(income_tax.order) }
  end

  describe 'luxury_tax' do
    let!(:player) { create(:player, game: game, position: 32) }

    let!(:luxury_tax) { create(:place, :luxury_tax) }

    before(:each) { MovePlayerToService.call(game: game, player: player, dice: [3, 3], position: luxury_tax.order) }

    it { expect(player.reload.money).to eq(3000 - Place::LUXURY_TAX_AMOUNT) }
    it { expect(player.reload.position).to eq(luxury_tax.order) }
  end
end
