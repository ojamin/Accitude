class AttachEverythingToProject < ActiveRecord::Migration
  def self.up
	
		add_column :all_invoices, :project_id, :integer
		add_column :all_expenses, :project_id, :integer
		add_column :all_liabilities, :project_id, :integer
		add_column :payment_plans, :project_id, :integer
		add_column :quotes, :project_id, :integer
		add_column :transactions, :project_id, :integer

	end

  def self.down

		remove_column :all_invoices, :project_id
		remove_column :all_expenses, :project_id
		remove_column :all_liabilities, :project_id
		remove_column :payment_plans, :project_id
		remove_column :quotes, :project_id
		remove_column :transactions, :project_id
		

	end
end
