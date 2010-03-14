class AddTypeToLiabilities < ActiveRecord::Migration
  def self.up
    add_column :liabilities, :type, :string
  end

  def self.down
    remove_column :liabilities, :type
  end
end
