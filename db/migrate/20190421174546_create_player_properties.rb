class CreatePlayerProperties < ActiveRecord::Migration[5.2]
  def change
    create_table :player_properties do |t|
      t.boolean :mortgaged, default: false

      t.integer :house_count, default: 0
      t.boolean :hotel, default: false

      t.references :game, index: true
      t.references :player, index: true
      t.references :property, index: true

      t.timestamps
    end
  end
end
