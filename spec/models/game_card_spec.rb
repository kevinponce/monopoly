# == Schema Information
#
# Table name: game_cards
#
#  id         :integer          not null, primary key
#  order      :integer
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  card_id    :integer
#  game_id    :integer
#  player_id  :integer
#
# Indexes
#
#  index_game_cards_on_card_id    (card_id)
#  index_game_cards_on_game_id    (game_id)
#  index_game_cards_on_player_id  (player_id)
#

require 'rails_helper'

describe GameCard, type: :model do
  describe 'associations' do
    it { should belong_to(:game) }
    it { should belong_to(:card) }
    it { should belong_to(:player) }
  end

  describe 'validations' do
    it { should validate_presence_of(:card) }
    it { should validate_presence_of(:game) }
  end

  describe 'scopes' do
    let!(:game) { create(:game) }
    let!(:player) { create(:player, game: game) }

    let!(:community_chest_1) { create(:card, :community_chest) }
    let!(:community_chest_2) { create(:card, :community_chest, :go_to_jail) }

    let!(:chance_1) { create(:card, :get_out_of_jail) }
    let!(:chance_2) { create(:card, :move_back_3_spaces) }
    let!(:chance_3) { create(:card, :move_to_park_place) }
    let!(:chance_4) { create(:card, :collection_25_from_each_players) }

    before(:each) do
      create(:game_card, card: community_chest_1, game: game)
      create(:game_card, card: community_chest_2, game: game)

      create(:game_card, card: chance_1, game: game, player: player, order: nil)
      create(:game_card, card: chance_2, game: game)
      create(:game_card, card: chance_3, game: game)
      create(:game_card, card: chance_4, game: game)
    end

    it { expect(GameCard.count).to eq(6) }
    it { expect(GameCard.active.count).to eq(5) }
    it { expect(GameCard.chance.count).to eq(4) }
    it { expect(GameCard.community_chest.count).to eq(2) }
  end
end
