class CreatePropertyGroup < ActiveRecord::Migration[5.2]
  def change
    create_table :property_groups do |t|
      t.string :color
      t.timestamps
    end
  end
end
