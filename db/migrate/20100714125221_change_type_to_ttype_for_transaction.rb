class ChangeTypeToTtypeForTransaction < ActiveRecord::Migration
  def self.up
		rename_column :transactions, :type, :ttype
	end

  def self.down
		rename_column :transactions, :ttype, :type
  end
end
