FactoryBot.define do
  factory :place do
    order { 0 }
    kind { Place::Kinds::PROPERTY }

    trait :park_place do
      order { 37 }
      kind { Place::Kinds::PROPERTY }
    end

    trait :jail do
      order { 10 }
      kind { Place::Kinds::JAIL }
    end

    trait :chance do
      order { 7 }
      kind { Place::Kinds::CHANCE }
    end

    trait :community_chest do
      order { 2 }
      kind { Place::Kinds::COMMUNITY_CHEST }
    end

    trait :income_tax do
      order { 4 }
      kind { Place::Kinds::INCOME_TAX }
    end

    trait :go_to_jail do
      order { 30 }
      kind { Place::Kinds::GO_TO_JAIL }
    end

    trait :luxury_tax do
      order { 38 }
      kind { Place::Kinds::LUXURY_TAX }
    end

    trait :free_parking do
      order { 20 }
      kind { Place::Kinds::FREE_PARKING }
    end
  end
end
