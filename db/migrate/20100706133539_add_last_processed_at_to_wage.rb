class AddLastProcessedAtToWage < ActiveRecord::Migration
  def self.up
		add_column :wages, :last_processed_at, :date
	end

  def self.down
		remove_column :wages, :last_processed_at
  end
end
