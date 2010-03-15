class AddTypeToExpense < ActiveRecord::Migration
  def self.up
    add_column :expenses, :type, :string
  end

  def self.down
    remove_column :expenses, :type
  end
end
