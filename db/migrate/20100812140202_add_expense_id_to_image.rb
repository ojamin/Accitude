class AddExpenseIdToImage < ActiveRecord::Migration
  def self.up
		add_column :images, :expense_id, :integer
	end

  def self.down
		remove_column :images, :expense_id
  end
end
