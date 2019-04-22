FactoryBot.define do
  factory :card do
    description { 'collect 5 dollars' }
    amount { 5 }
    action { Card::Actions::COLLECT }
    kind { Card::Kinds::CHANCE }

    trait :community_chest do
      kind { Card::Kinds::COMMUNITY_CHEST }
    end

    trait :get_out_of_jail do
      description { 'Get out of jail free' }
      action { Card::Actions::GET_OUT_OF_JAIL }
      amount { nil }
    end

    trait :go_to_jail do
      description { 'Go To Jail Go directly to Jail. Do not pass GO, do not collect $200' }
      action { Card::Actions::GO_TO_JAIL }
      amount { 10 }
    end

    trait :move_back_3_spaces do
      description { 'move back 3 spaces' }
      action { Card::Actions::MOVE }
      amount { -3 }
    end

    trait :move_to_park_place do
      description { 'advance to park place' }
      action { Card::Actions::ADVANCE_TO }
      amount { 37 }
    end

    trait :collection_25_from_each_players do
      description { 'collect 25 dollars from each players' }
      action { Card::Actions::COLLECT_FROM_EACH_PLAYERS }
      amount { 25 }
    end
  end
end
