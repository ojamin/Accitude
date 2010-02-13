class OrganisationsUsers < ActiveRecord::Migration
  def self.up
    create_table :organisations_users, :id => false do |t|
      t.integer :organisation_id
      t.integer :user_id
    end
  end

  def self.down
    drop_table :organisations_users
  end
end
