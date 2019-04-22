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

class Game < ActiveRecord::Base
  has_many :players
  has_many :game_cards
  has_many :player_properties

  INIT_JACKPOT = 500

  module Statuses
    PENDING = 'pending'.freeze
    STARTED = 'start'.freeze
    OVER = 'over'.freeze
    CANCELLED = 'cancelled'.freeze
    ALL = [PENDING, STARTED, OVER, CANCELLED].freeze
  end

  validates :status, inclusion: Statuses::ALL
  validates :status, :title, presence: true

  before_create :set_jackpot

  def started?
    status == Statuses::STARTED
  end

  def over?
    status == Statuses::OVER
  end

  def cancelled?
    status == Statuses::CANCELLED
  end

  def start!
    update(status: Statuses::STARTED)
  end

  def over!
    update(status: Statuses::OVER)
  end

  def cancelled!
    update(status: Statuses::CANCELLED)
  end

  def current_player
    players.find_by(order: turn)
  end

  def reset_jackpot!
    update(jackpot: INIT_JACKPOT)
  end

  def next_player!
    if turn >= (players.length - 1)
      update(turn: 0)
    else
      increment!(:turn)
    end
  end

  private

  def set_jackpot
    self.jackpot = INIT_JACKPOT
  end
end
