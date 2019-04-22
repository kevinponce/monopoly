# == Schema Information
#
# Table name: players
#
#  id                     :integer          not null, primary key
#  in_jail                :boolean          default(FALSE)
#  money                  :integer
#  name                   :integer
#  number_of_doubles      :integer          default(0)
#  order                  :integer
#  position               :integer          default(0)
#  roll_out_of_jail_count :integer          default(0)
#  created_at             :datetime         not null
#  updated_at             :datetime         not null
#  game_id                :integer
#  user_id                :integer
#
# Indexes
#
#  index_players_on_game_id  (game_id)
#  index_players_on_user_id  (user_id)
#

require 'rails_helper'

describe Player, type: :model do
  describe 'associations' do
    it { should belong_to(:game) }
    it { should belong_to(:user) }

    it { should have_many(:game_cards) }
    it { should have_many(:player_properties) }
  end

  describe 'validations' do
    it { should validate_presence_of(:number_of_doubles) }
    it { should validate_presence_of(:position) }
    it { should validate_presence_of(:roll_out_of_jail_count) }
    it { should validate_presence_of(:game) }
    it { should validate_presence_of(:name) }
  end

  describe 'before_create' do
    it { expect(create(:player, money: nil).money).to eq(Player::INIT_MONEY) }
  end

  describe 'methods' do
    it '#current_place' do
      jail = create(:place, :jail)
      player = create(:player, position: jail.order)

      expect(player.current_place).to eq(jail)
    end

    describe '#current_place_purchasable?' do
      it 'visiting jail' do
        jail = create(:place, :jail)
        player = create(:player, position: jail.order)

        expect(player.current_place_purchasable?).to be_falsey
      end
    end
  end
end
