class AddPhone2ToContact < ActiveRecord::Migration
  def self.up
    add_column :contacts, :phone2, :string
  end

  def self.down
    remove_column :contacts, :phone2
  end
end
