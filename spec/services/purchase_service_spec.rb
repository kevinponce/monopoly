require 'rails_helper'

describe PurchaseService do
  let!(:game) { create(:game) }
  let!(:player_1) { create(:player, game: game, position: 4) }
  let!(:player_2) { create(:player, game: game) }
  let!(:rail_road) { create(:property, :rail_road) }
  let!(:place) { create(:place, order: 4, property: rail_road) }

  let(:ps) { PurchaseService.call(game: game, player: player_1) }

  describe 'not purchased' do
    it { expect(ps.errors).to be_empty }
    it 'purchase' do
      ps
      expect(player_1.reload.player_properties.length).to eq(1)
    end

    it 'not enough money' do
      player_1.update(money: 10)
      expect(ps.errors).to_not be_empty
    end
  end

  describe 'already purchased' do
    let!(:player_2_property) { create(:player_property, game: game, player: player_2, property: rail_road) }

    it { expect(ps.errors).to_not be_empty }
  end
end
