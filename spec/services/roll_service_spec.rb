require 'rails_helper'

describe RollService do
  let!(:game) { create(:game, turn: 0) }
  let!(:property) { create(:property, :basic) }
  describe 'number_of_doubles: 0' do
    let!(:player_1) { create(:player, game: game, order: 0, position: 0) }
    let!(:player_2) { create(:player, game: game, order: 1) }

    describe 'regular turn' do
      let!(:place) { create(:place, order: 9, property: property) }

      before(:each) do
        allow_any_instance_of(RollService).to receive(:dice).and_return([3, 6])
        RollService.call(game: game, player: player_1)
      end

      it { expect(game.reload.current_player.id).to eq(player_1.id) } # same player turn because they can purchase it
    end

    it 'doubles' do
      create(:place, order: 4, property: property)

      allow_any_instance_of(Object).to receive(:rand).and_return(1)
      RollService.call(game: game, player: player_1)
      expect(game.reload.current_player.id).to eq(player_1.id)
      expect(player_1.reload.number_of_doubles).to eq(1)
    end
  end

  describe 'number_of_doubles: 2' do
    let!(:player_1) { create(:player, game: game, order: 0, number_of_doubles: 2) }
    let!(:player_2) { create(:player, game: game, order: 1) }
    let!(:place) { create(:place, order: 4, property: property) }

    before(:each) do
      allow_any_instance_of(Object).to receive(:rand).and_return(1)
      RollService.call(game: game, player: player_1)
    end

    it { expect(game.reload.current_player.id).to eq(player_2.id) }
    it { expect(player_1.reload.number_of_doubles).to eq(0) }
    it { expect(player_1.reload.in_jail).to be_truthy }
    it { expect(player_1.reload.position).to eq(10) }
  end
end
