class CreateGames < ActiveRecord::Migration[5.2]
  def change
    create_table :games do |t|
      t.string :title
      t.integer :turn, default: 0
      t.integer :jackpot, default: 0
      t.string :status, default: Game::Statuses::PENDING
      t.timestamps
    end
  end
end
