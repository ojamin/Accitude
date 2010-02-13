class CreateQuotes < ActiveRecord::Migration
  def self.up
    create_table :quotes do |t|
      t.integer :contact_id
      t.integer :organisation_id
      t.date :produced_on
      t.date :valid_till

      t.timestamps
    end
  end

  def self.down
    drop_table :quotes
  end
end
