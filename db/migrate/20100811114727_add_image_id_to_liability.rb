class AddImageIdToLiability < ActiveRecord::Migration
  def self.up
    add_column :all_liabilities, :image_id, :integer
  end

  def self.down
    remove_column :all_liabilities, :image_id
  end
end
