class AddAreaRangesToPartner < ActiveRecord::Migration[6.0]
  def change
    add_column :partners, :min_area, :integer
    add_column :partners, :max_area, :integer
  end
end
