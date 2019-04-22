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

class GameCard < ActiveRecord::Base
  belongs_to :game
  belongs_to :card
  belongs_to :player, optional: true

  validates :card, :game, presence: true

  scope :chance, -> { joins(:card).where('cards.kind = ?', Card::Kinds::CHANCE) }
  scope :community_chest, -> { joins(:card).where('cards.kind = ?', Card::Kinds::COMMUNITY_CHEST) }
  scope :active, -> { where.not(order: nil) }
end
