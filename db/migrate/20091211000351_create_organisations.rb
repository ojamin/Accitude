class CreateOrganisations < ActiveRecord::Migration
  def self.up
    create_table :organisations do |t|
      t.date :period
      t.string :name

      t.timestamps
    end
  end

  def self.down
    drop_table :organisations
  end
end
