# == Schema Information
#
# Table name: player_properties
#
#  id          :integer          not null, primary key
#  hotel       :boolean          default(FALSE)
#  house_count :integer          default(0)
#  mortgaged   :boolean          default(FALSE)
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#  game_id     :integer
#  player_id   :integer
#  property_id :integer
#
# Indexes
#
#  index_player_properties_on_game_id      (game_id)
#  index_player_properties_on_player_id    (player_id)
#  index_player_properties_on_property_id  (property_id)
#

require 'rails_helper'

describe PlayerProperty, type: :model do
  describe 'associations' do
    it { should belong_to(:game) }
    it { should belong_to(:player) }
    it { should belong_to(:property) }

    it { should have_one(:property_group) }
  end

  describe 'validations' do
    it { should validate_presence_of(:player) }
    it { should validate_presence_of(:game) }

    it { expect(build(:player_property, house_count: 0)).to be_valid }
    it { expect(build(:player_property, house_count: 1)).to be_valid }
    it { expect(build(:player_property, house_count: 2)).to be_valid }
    it { expect(build(:player_property, house_count: 3)).to be_valid }
    it { expect(build(:player_property, house_count: 4)).to be_valid }
    it { expect(build(:player_property, house_count: 5)).to_not be_valid }
    it { expect(build(:player_property, house_count: -1)).to_not be_valid }
  end

  describe 'methods' do
    let(:blue_property_group) { create(:property_group, color: 'blue') }
    let(:park_place) { create(:property, :basic, property_group: blue_property_group, title: 'Park Place') }
    let(:boardwalk) { create(:property, :basic, property_group: blue_property_group, title: 'Boardwalk') }

    let(:rail_road_property_group) { create(:property_group, color: 'rail_road') }
    let(:rail_road_1) { create(:property, :rail_road, property_group: rail_road_property_group) }
    let!(:rail_road_2) { create(:property, :rail_road, property_group: rail_road_property_group) }
    let!(:rail_road_3) { create(:property, :rail_road, property_group: rail_road_property_group) }
    let!(:rail_road_4) { create(:property, :rail_road, property_group: rail_road_property_group) }

    let(:game) { create(:game) }
    let(:player) { create(:player, game: game) }

    describe '#house?' do
      it { expect(build(:player_property, house_count: 0).house?).to be_falsey }
      it { expect(build(:player_property, house_count: 1).house?).to be_truthy }
      it { expect(build(:player_property, house_count: 4).house?).to be_truthy }
    end

    describe '#grouped_properties_own_by_user_count' do
      describe 'two blue and rail road properties belonging to same user' do
        let!(:player_park_place) { create(:player_property, game: game, player: player, property: park_place) }
        let!(:player_boardwalk) { create(:player_property, game: game, player: player, property: boardwalk) }
        let!(:player_rail_road) { create(:player_property, game: game, player: player, property: rail_road_1) }

        it { expect(player_park_place.grouped_properties_own_by_user_count).to eq(2) }
        it { expect(player_rail_road.grouped_properties_own_by_user_count).to eq(1) }
      end
    end

    describe '#monopoly?' do
      describe 'two blue and rail road properties belonging to same user' do
        let!(:player_park_place) { create(:player_property, game: game, player: player, property: park_place) }
        let!(:player_boardwalk) { create(:player_property, game: game, player: player, property: boardwalk) }
        let!(:player_rail_road) { create(:player_property, game: game, player: player, property: rail_road_1) }

        it { expect(player_park_place.monopoly?).to be_truthy }
        it { expect(player_rail_road.monopoly?).to be_falsey }
      end
    end
  end
end
