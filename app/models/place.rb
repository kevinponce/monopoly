# == Schema Information
#
# Table name: places
#
#  id          :integer          not null, primary key
#  kind        :string
#  order       :integer
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#  property_id :integer
#
# Indexes
#
#  index_places_on_property_id  (property_id)
#

class Place < ActiveRecord::Base
  belongs_to :property, optional: true

  INCOME_TAX_AMOUNT = 200
  LUXURY_TAX_AMOUNT = 75

  module Kinds
    GO = 'go'.freeze
    CHANCE = 'chance'.freeze
    COMMUNITY_CHEST = 'community_chest'.freeze
    JAIL = 'jail'.freeze
    FREE_PARKING = 'free_parking'.freeze
    GO_TO_JAIL = 'go_to_jail'.freeze
    INCOME_TAX = 'income_tax'.freeze
    LUXURY_TAX = 'luxury_tax'.freeze
    
    PROPERTY = 'property'.freeze

    ALL = [GO, CHANCE, COMMUNITY_CHEST, JAIL, FREE_PARKING, GO_TO_JAIL, INCOME_TAX, LUXURY_TAX, PROPERTY].freeze
  end

  validates :kind, inclusion: Kinds::ALL

  def property?
    kind == Kinds::PROPERTY
  end

  def chance?
    kind == Kinds::CHANCE
  end

  def community_chest?
    kind == Kinds::COMMUNITY_CHEST
  end

  def go_to_jail?
    kind == Kinds::GO_TO_JAIL
  end

  def free_parking?
    kind == Kinds::FREE_PARKING
  end

  def income_tax?
    kind == Kinds::INCOME_TAX
  end

  def luxury_tax?
    kind == Kinds::LUXURY_TAX
  end
end
