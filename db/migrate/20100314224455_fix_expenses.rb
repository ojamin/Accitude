class FixExpenses < ActiveRecord::Migration
  def self.up
    AllExpense.find(:all).each {|i|
      i[:type] = "Expense"
      i.save
    }
  end

  def self.down
  end
end
