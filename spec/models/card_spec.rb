# == Schema Information
#
# Table name: cards
#
#  id          :integer          not null, primary key
#  action      :string
#  amount      :integer          default(0)
#  description :text
#  kind        :string
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#

require 'rails_helper'

describe Card, type: :model do
  describe 'associations' do
    it { should have_many(:game_cards) }
  end

  describe 'validations' do
    it { expect(build(:card)).to be_valid }
    it { expect(build(:card, :community_chest)).to be_valid }
    it { expect(build(:card, :get_out_of_jail)).to be_valid }
    it { expect(build(:card, :go_to_jail)).to be_valid }
    it { expect(build(:card, :move_back_3_spaces)).to be_valid }
    it { expect(build(:card, :move_to_park_place)).to be_valid }
    it { expect(build(:card, :collection_25_from_each_players)).to be_valid }
    it { expect(build(:card, kind: 'invalid_kind')).to_not be_valid }
    it { expect(build(:card, action: 'invalid_action')).to_not be_valid }

    it{ should validate_presence_of(:description) }
  end

  describe 'scopes' do
    let!(:chance_1) { create(:card) }
    let!(:chance_2) { create(:card) }
    let!(:community_chest_1) { create(:card, :community_chest) }
    let!(:community_chest_2) { create(:card, :community_chest) }
    let!(:community_chest_3) { create(:card, :community_chest) }

    it { expect(Card.chance.count).to eq(2) }
    it { expect(Card.community_chest.count).to eq(3) }

    it { expect(Card.chance).to include(chance_1) }
    it { expect(Card.chance).to include(chance_2) }
    it { expect(Card.chance).to_not include(community_chest_1) }

    it { expect(Card.community_chest).to include(community_chest_1) }
    it { expect(Card.community_chest).to include(community_chest_2) }
    it { expect(Card.community_chest).to include(community_chest_3) }
    it { expect(Card.community_chest).to_not include(chance_2) }
  end

  describe 'methods' do
    describe '#chance?' do
      it { expect(build(:card).chance?).to be_truthy }
      it { expect(build(:card, :community_chest).chance?).to_not be_truthy }
    end

    describe '#community_chest?' do
      it { expect(build(:card).community_chest?).to_not be_truthy }
      it { expect(build(:card, :community_chest).community_chest?).to be_truthy }
    end
  end
end
