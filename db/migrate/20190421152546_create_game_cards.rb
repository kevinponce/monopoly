class CreateGameCards < ActiveRecord::Migration[5.2]
  def change
    create_table :game_cards do |t|
      t.integer :order

      t.references :game, index: true
      t.references :card, index: true
      t.references :player, index: true
      t.timestamps
    end
  end
end
