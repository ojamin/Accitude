class RenameExpenseToAllExpense < ActiveRecord::Migration
  def self.up
    rename_table :expenses, :all_expenses
  end

  def self.down
    rename_table :all_expenses, :expenses
  end
end
