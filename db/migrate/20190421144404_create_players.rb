class CreatePlayers < ActiveRecord::Migration[5.2]
  def change
    create_table :players do |t|
      t.integer :name
      t.integer :order
      t.integer :money
      t.integer :position, default: 0
      t.boolean :in_jail, default: false
      t.integer :roll_out_of_jail_count, default: 0
      t.integer :number_of_doubles, default: 0

      t.references :game, index: true
      t.references :user, index: true
      t.timestamps
    end
  end
end
