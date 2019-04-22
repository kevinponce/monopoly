# == Schema Information
#
# Table name: property_groups
#
#  id         :integer          not null, primary key
#  color      :string
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

require 'rails_helper'

describe PropertyGroup, type: :model do
  describe 'associations' do
    it { should have_many(:properties) }
  end

  describe 'validations' do
    it { should validate_presence_of(:color) }
  end
end
