# == Schema Information
#
# Table name: games
#
#  id         :integer          not null, primary key
#  jackpot    :integer          default(0)
#  status     :string           default("pending")
#  title      :string
#  turn       :integer          default(0)
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

require 'rails_helper'

describe Game, type: :model do
  describe 'associations' do
    it { should have_many(:players) }
    it { should have_many(:game_cards) }
    it { should have_many(:player_properties) }
  end

  describe 'validations' do
    it { expect(build(:game)).to be_valid }
    it { expect(build(:game, status: Game::Statuses::PENDING)).to be_valid }
    it { expect(build(:game, status: Game::Statuses::STARTED)).to be_valid }
    it { expect(build(:game, status: Game::Statuses::OVER)).to be_valid }
    it { expect(build(:game, status: Game::Statuses::CANCELLED)).to be_valid }
    it { expect(build(:game, status: 'invalid_status')).to_not be_valid }

    it { should validate_presence_of(:status) }
    it { should validate_presence_of(:title) }
  end

  describe 'before_create' do
    it { expect(create(:game, jackpot: nil).jackpot).to eq(Game::INIT_JACKPOT) }
  end

  describe 'methods' do
    let!(:game) { create(:game, jackpot: 1000, turn: 0) }

    it '#started?' do
      expect(build(:game, status: Game::Statuses::STARTED).started?).to be_truthy
    end

    it '#over?' do
      expect(build(:game, status: Game::Statuses::OVER).over?).to be_truthy
    end

    it '#cancelled?' do
      expect(build(:game, status: Game::Statuses::CANCELLED).cancelled?).to be_truthy
    end

    it '#start!' do
      game.start!
      expect(game.reload.status).to eq(Game::Statuses::STARTED)
    end

    it '#over!' do
      game.over!
      expect(game.reload.status).to eq(Game::Statuses::OVER)
    end

    it '#cancelled!' do
      game.cancelled!
      expect(game.reload.status).to eq(Game::Statuses::CANCELLED)
    end

    it '#current_player' do
      player_1 = create(:player, game: game, order: 0)
      player_2 = create(:player, game: game, order: 1)
      expect(game.current_player).to eq(player_1)
    end

    it '#reset_jackpot!' do
      game.reset_jackpot!
      expect(game.reload.jackpot).to eq(Game::INIT_JACKPOT)
    end
  end
end
