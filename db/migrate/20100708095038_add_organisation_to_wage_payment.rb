class AddOrganisationToWagePayment < ActiveRecord::Migration
  def self.up
		add_column :wage_payments, :organisation_id, :integer
	end

  def self.down
		remove_column :wage_payments, :organisation_id
  end
end
