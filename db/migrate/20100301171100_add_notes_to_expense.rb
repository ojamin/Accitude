class AddNotesToExpense < ActiveRecord::Migration
  def self.up
    add_column :expenses, :notes, :text
  end

  def self.down
    remove_column :expenses, :notes
  end
end
