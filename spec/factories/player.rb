FactoryBot.define do
  factory :player do 
    name { 'example' }   
    money { 3000 }
    order { 37 }
    position { 0 }
    in_jail { false }
    game
    user

  end
end
