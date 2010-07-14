class AddOrganisationToTransaction < ActiveRecord::Migration
  def self.up
		add_column :Transactions, :organisation_id, :integer
	end

  def self.down
		remove_column :Transactions, :organisation_id
  end
end
