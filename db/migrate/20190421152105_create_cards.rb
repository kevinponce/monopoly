class CreateCards < ActiveRecord::Migration[5.2]
  def change
    create_table :cards do |t|
      t.text :description
      t.string :kind
      t.string :action

      t.integer :amount, default: 0
      t.timestamps
    end
  end
end
