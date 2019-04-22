# == Schema Information
#
# Table name: properties
#
#  id                :integer          not null, primary key
#  can_build_hotel   :integer
#  hotel_rent        :integer
#  house_rent_1      :integer
#  house_rent_2      :integer
#  house_rent_3      :integer
#  house_rent_4      :integer
#  kind              :string
#  max_house_count   :integer
#  monopoly_rent     :integer
#  mortgage_value    :integer          not null
#  price             :integer
#  price_per_hotel   :integer
#  price_per_house   :integer
#  rent              :integer
#  title             :string
#  created_at        :datetime         not null
#  updated_at        :datetime         not null
#  property_group_id :integer
#
# Indexes
#
#  index_properties_on_property_group_id  (property_group_id)
#

class Property < ActiveRecord::Base
  belongs_to :property_group

  module Kinds
    BASIC = 'basic'.freeze
    RAIL_ROAD = 'rail_road'.freeze
    UTILITY = 'utility'.freeze

    ALL = [BASIC, RAIL_ROAD, UTILITY].freeze
  end

  validates :kind, inclusion: Kinds::ALL
  validates :title,
            :price,
            :max_house_count,
            :can_build_hotel,
            :mortgage_value,
            :property_group, presence: true
  validates :rent, presence: true, if: -> { kind == Kinds::RAIL_ROAD }
  validates :price_per_house,
            :price_per_hotel,
            :rent,
            :house_rent_1,
            :house_rent_2,
            :house_rent_3,
            :house_rent_4,
            :hotel_rent, presence: true, if: -> { kind == Kinds::BASIC }

  def rail_road?
    kind == Kinds::RAIL_ROAD
  end

  def utility?
    kind == Kinds::UTILITY
  end
end
