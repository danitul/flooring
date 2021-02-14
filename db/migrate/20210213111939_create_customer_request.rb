class CreateCustomerRequest < ActiveRecord::Migration[6.0]
  def change
    create_table :customer_requests do |t|
      t.string :material
      t.float :lat
      t.float :lng
      t.integer :area
      t.string :phone

      t.timestamps
    end
  end
end
