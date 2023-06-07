class CreateFlatEquipments < ActiveRecord::Migration[7.0]
  def change
    create_table :flat_equipments do |t|
      t.references :flat, null: false, foreign_key: true
      t.references :equipment, null: false, foreign_key: true

      t.timestamps
    end
  end
end
