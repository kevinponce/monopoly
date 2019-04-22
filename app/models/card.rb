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

class Card < ActiveRecord::Base
  has_many :game_cards

  module Kinds
    CHANCE = 'chance'.freeze
    COMMUNITY_CHEST = 'community_chest'.freeze

    ALL = [CHANCE, COMMUNITY_CHEST].freeze
  end

  module Actions
    GET_OUT_OF_JAIL = 'get_out_of_jail'.freeze
    GO_TO_JAIL = 'go_to_jail'.freeze
    MOVE = 'move'.freeze
    ADVANCE_TO = 'advace_to'.freeze
    COLLECT = 'collect'.freeze
    COLLECT_FROM_EACH_PLAYERS = 'collect_from_each_players'.freeze

    ALL = [GET_OUT_OF_JAIL, GO_TO_JAIL, MOVE, ADVANCE_TO, COLLECT, COLLECT_FROM_EACH_PLAYERS].freeze
  end

  validates :kind, inclusion: Kinds::ALL
  validates :action, inclusion: Actions::ALL
  validates :description, presence: true

  scope :chance, -> { where(kind: Kinds::CHANCE) }
  scope :community_chest, -> { where(kind: Kinds::COMMUNITY_CHEST) }

  def chance?
    kind == Kinds::CHANCE
  end

  def community_chest?
    kind == Kinds::COMMUNITY_CHEST
  end
end
