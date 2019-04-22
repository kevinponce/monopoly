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

require 'rails_helper'

describe Property, type: :model do
  describe 'associations' do
    it { should belong_to(:property_group) }
  end

  describe 'validations' do
    it { expect(build(:property, :basic)).to be_valid }
    it { expect(build(:property, :rail_road)).to be_valid }
    it { expect(build(:property, :utility)).to be_valid }
    it { expect(build(:property, kind: 'invalid_kind')).to_not be_valid }

    it { should validate_presence_of(:title) }
    it { should validate_presence_of(:price) }
    it { should validate_presence_of(:max_house_count) }
    it { should validate_presence_of(:can_build_hotel) }
    it { should validate_presence_of(:mortgage_value) }
    it { should validate_presence_of(:property_group) }
  end

  describe 'methods' do
    describe '#rail_road?' do
      it { expect(build(:property, :rail_road).rail_road?).to be_truthy }
    end

    describe '#utility?' do
      it { expect(build(:property, :utility).utility?).to be_truthy }
    end
  end
end
