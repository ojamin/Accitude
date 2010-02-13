class AddValueToLiability < ActiveRecord::Migration
  def self.up
    add_column :liabilities, :value, :float
  end

  def self.down
    remove_column :liabilities, :value
  end
end
