class CreatePlaces < ActiveRecord::Migration[5.2]
  def change
    create_table :places do |t|
      t.integer :order
      t.string :kind

      t.references :property, index: true, optional: true

      t.timestamps
    end
  end
end
