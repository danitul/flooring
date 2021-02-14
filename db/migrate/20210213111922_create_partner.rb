class CreatePartner < ActiveRecord::Migration[6.0]
  def change
    create_table :partners do |t|
      t.string :materials, array: true, default: []
      t.float :lat
      t.float :lng
      t.integer :radius
      t.float :rating

      t.timestamps
    end
  end
end
