class CreateContacts < ActiveRecord::Migration
  def self.up
    create_table :contacts do |t|
      t.integer :quote_id
      t.integer :invoice_id
      t.integer :organisation_id
      t.string :company
      t.string :name
      t.string :street
      t.text :address
      t.string :postcode
      t.string :phone
      t.string :fax
      t.string :email
      t.boolean :customer
      t.boolean :supplier

      t.timestamps
    end
  end

  def self.down
    drop_table :contacts
  end
end
