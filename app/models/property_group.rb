# == Schema Information
#
# Table name: property_groups
#
#  id         :integer          not null, primary key
#  color      :string
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

class PropertyGroup < ActiveRecord::Base
  has_many :properties

  validates :color, presence: true
end
