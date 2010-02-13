class CreateLiabilities < ActiveRecord::Migration
  def self.up
    create_table :liabilities do |t|
      t.integer :contact_id
      t.integer :organisation_id
      t.date :incurred_on
      t.date :paid_on
      t.text :information
      t.string :receipt_id
      t.boolean :processed

      t.timestamps
    end
  end

  def self.down
    drop_table :liabilities
  end
end
