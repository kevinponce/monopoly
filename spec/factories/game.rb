FactoryBot.define do
  factory :game do
    title { 'Game 1' }

    jackpot { Game::INIT_JACKPOT }
    turn { 0 }
    status { Game::Statuses::STARTED }
  end
end
