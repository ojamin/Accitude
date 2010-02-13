class AddWebsiteToContact < ActiveRecord::Migration
  def self.up
    add_column :contacts, :website, :string
  end

  def self.down
    remove_column :contacts, :website
  end
end
