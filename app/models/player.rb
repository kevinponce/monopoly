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

class Player < ActiveRecord::Base
  belongs_to :game
  belongs_to :user

  has_many :game_cards
  has_many :player_properties

  before_create :set_money

  INIT_MONEY = 3000

  validates :name,
            :number_of_doubles,
            :position,
            :roll_out_of_jail_count,
            :game, presence: true
  validates :game_id, uniqueness: { scope: :user_id }

  def current_place
    Place.find_by(order: position)
  end

  def current_property
    cp = current_place
    return unless cp.property?

    cp.property
  end

  def current_place_purchasable?
    cp = current_place
    return false unless cp.property?

    game.player_properties.find_by(property_id: cp.property_id).nil?
  end

  private

  def set_money
    self.money = INIT_MONEY
  end
end
