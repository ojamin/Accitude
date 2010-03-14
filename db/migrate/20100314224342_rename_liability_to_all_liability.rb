class RenameLiabilityToAllLiability < ActiveRecord::Migration
  def self.up
    rename_table :liabilities, :all_liabilities
  end

  def self.down
    rename_table :all_liabilities, :liabilities
  end
end
