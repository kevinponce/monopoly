FactoryBot.define do
  factory :game_card do
    order { 0 }

    card
    game
    player
  end
end
