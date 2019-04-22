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

class PlayerProperty < ActiveRecord::Base
  belongs_to :game
  belongs_to :player
  belongs_to :property
  has_one :property_group, through: :property

  validates_inclusion_of :house_count, in: 0..4
  validates :player,
            :game, presence: true

  def house?
    house_count > 0
  end

  def grouped_properties_own_by_user_count
    game.player_properties.joins(:property).where(player: player, properties: { property_group: property_group }).count
  end

  def monopoly?
    property_group.properties.count == grouped_properties_own_by_user_count
  end
end
