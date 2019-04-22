class CreateProperties < ActiveRecord::Migration[5.2]
  def change
    create_table :properties do |t|
      t.string :title
      t.string :kind, defaults: Property::Kinds::BASIC

      t.integer :price

      t.integer :price_per_house
      t.integer :price_per_hotel

      t.integer :max_house_count
      t.integer :can_build_hotel

      t.integer :rent
      t.integer :monopoly_rent
      t.integer :house_rent_1
      t.integer :house_rent_2
      t.integer :house_rent_3
      t.integer :house_rent_4
      t.integer :hotel_rent

      t.integer :mortgage_value, null: false

      t.references :property_group, index: true

      t.timestamps
    end
  end
end
