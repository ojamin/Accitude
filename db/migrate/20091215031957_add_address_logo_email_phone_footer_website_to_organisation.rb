class AddAddressLogoEmailPhoneFooterWebsiteToOrganisation < ActiveRecord::Migration
  def self.up
    add_column :organisations, :address, :text
    add_column :organisations, :logo, :binary
    add_column :organisations, :email, :string
    add_column :organisations, :phone, :string
    add_column :organisations, :footer, :text
    add_column :organisations, :website, :string
  end

  def self.down
    remove_column :organisations, :website
    remove_column :organisations, :footer
    remove_column :organisations, :phone
    remove_column :organisations, :email
    remove_column :organisations, :logo
    remove_column :organisations, :address
  end
end
