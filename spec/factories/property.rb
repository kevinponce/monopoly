FactoryBot.define do
  factory :property do
    price { 350 }
    mortgage_value { 175 }

    property_group

    trait :basic do
      title { 'Park Place' }
      rent { 35 }
      house_rent_1 { 175 }
      house_rent_2 { 500 }
      house_rent_3 { 1100 }
      house_rent_4 { 1300 }
      hotel_rent { 1500 }
      monopoly_rent { 70 }

      max_house_count { 4 }
      can_build_hotel { true }

      price_per_hotel { 200 }
      price_per_house { 200 }

      kind { Property::Kinds::BASIC }
    end

    trait :rail_road do
      title { 'Reading Rail Road' }
      kind { Property::Kinds::RAIL_ROAD }
      rent { 25 }
      max_house_count { 0 }
      can_build_hotel { false }
    end

    trait :utility do
      title { 'Electric Company' }
      kind { Property::Kinds::UTILITY }
      max_house_count { 0 }
      can_build_hotel { false }
    end
  end
end
