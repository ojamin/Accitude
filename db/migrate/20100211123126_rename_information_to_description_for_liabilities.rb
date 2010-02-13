class RenameInformationToDescriptionForLiabilities < ActiveRecord::Migration
  def self.up
    rename_column :liabilities, :information, :description
  end
  def self.down
    rename_column :liabilities, :description, :information
  end
end
