class AddOrganisationToTransaction < ActiveRecord::Migration
  def self.up
    add_column :transactions, :organisation_id, :integer
  end

  def self.down
    remove_column :transactions, :organisation_id
  end
end
