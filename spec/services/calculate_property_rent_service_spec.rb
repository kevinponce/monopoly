require 'rails_helper'

describe CalculatePropertyRentService do
  describe 'basic property' do
    let!(:property_group) { create(:property_group) }
    let!(:basic_property) { create(:property, :basic, property_group: property_group) }
    let!(:basic_property_2) { create(:property, :basic, property_group: property_group) }

    describe 'no home or hotels' do
      let!(:player_property) { create(:player_property, property: basic_property) }

      it { expect(CalculatePropertyRentService.call(player_property, [])).to eq(basic_property.rent) }
    end

    describe '1 house' do
      let!(:player_property) { create(:player_property, property: basic_property, house_count: 1) }

      it { expect(CalculatePropertyRentService.call(player_property, [])).to eq(basic_property.house_rent_1) }
    end

    describe '2 house' do
      let!(:player_property) { create(:player_property, property: basic_property, house_count: 2) }

      it { expect(CalculatePropertyRentService.call(player_property, [])).to eq(basic_property.house_rent_2) }
    end

    describe '3 house' do
      let!(:player_property) { create(:player_property, property: basic_property, house_count: 3) }

      it { expect(CalculatePropertyRentService.call(player_property, [])).to eq(basic_property.house_rent_3) }
    end

    describe '4 house' do
      let!(:player_property) { create(:player_property, property: basic_property, house_count: 4) }

      it { expect(CalculatePropertyRentService.call(player_property, [])).to eq(basic_property.house_rent_4) }
    end

    describe 'hotel' do
      let!(:player_property) { create(:player_property, property: basic_property, hotel: true) }

      it { expect(CalculatePropertyRentService.call(player_property, [])).to eq(basic_property.hotel_rent) }
    end

    describe 'mortgaged' do
      let!(:player_property) { create(:player_property, property: basic_property, mortgaged: true) }

      it { expect(CalculatePropertyRentService.call(player_property, [])).to eq(0) }
    end
  end
end
