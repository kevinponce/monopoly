FactoryBot.define do
  factory :player_property do
    hotel { false }
    house_count { 0 }
    mortgaged { false }

    game
    player
    property
  end
end
