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

require 'rails_helper'

describe Place, type: :model do
  describe 'associations' do
    it { should belong_to(:property) }
  end

  describe 'validations' do
    it { expect(build(:place, kind: Place::Kinds::GO)).to be_valid }
    it { expect(build(:place, kind: Place::Kinds::CHANCE)).to be_valid }
    it { expect(build(:place, kind: Place::Kinds::COMMUNITY_CHEST)).to be_valid }
    it { expect(build(:place, kind: Place::Kinds::JAIL)).to be_valid }
    it { expect(build(:place, kind: Place::Kinds::FREE_PARKING)).to be_valid }
    it { expect(build(:place, kind: Place::Kinds::GO_TO_JAIL)).to be_valid }
    it { expect(build(:place, kind: Place::Kinds::INCOME_TAX)).to be_valid }
    it { expect(build(:place, kind: Place::Kinds::LUXURY_TAX)).to be_valid }
    it { expect(build(:place, kind: Place::Kinds::PROPERTY)).to be_valid }

    it { expect(build(:place, kind: 'invalid_kind')).to_not be_valid }
  end

  describe 'methods' do
    it '#property?' do
      expect(build(:place, kind: Place::Kinds::PROPERTY).property?).to be_truthy
    end

    it '#chance?' do
      expect(build(:place, kind: Place::Kinds::CHANCE).chance?).to be_truthy
    end

    it '#community_chest?' do
      expect(build(:place, kind: Place::Kinds::COMMUNITY_CHEST).community_chest?).to be_truthy
    end

    it '#go_to_jail?' do
      expect(build(:place, kind: Place::Kinds::GO_TO_JAIL).go_to_jail?).to be_truthy
    end

    it '#free_parking?' do
      expect(build(:place, kind: Place::Kinds::FREE_PARKING).free_parking?).to be_truthy
    end

    it '#income_tax?' do
      expect(build(:place, kind: Place::Kinds::INCOME_TAX).income_tax?).to be_truthy
    end

    it '#luxury_tax?' do
      expect(build(:place, kind: Place::Kinds::LUXURY_TAX).luxury_tax?).to be_truthy
    end
  end
end
