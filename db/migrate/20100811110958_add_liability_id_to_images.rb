class AddLiabilityIdToImages < ActiveRecord::Migration
  def self.up
		add_column :images, :liability_id, :integer
	end

  def self.down
		remove_column :images, :liability_id
  end
end
