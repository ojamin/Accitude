class ChangeLogoInOrganisation < ActiveRecord::Migration
  def self.up
    remove_column :organisations, :logo
  end

  def self.down
    add_column :organisations, :logo, :binary
  end
end
