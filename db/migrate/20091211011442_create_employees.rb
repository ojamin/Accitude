class CreateEmployees < ActiveRecord::Migration
  def self.up
    create_table :employees do |t|
      t.integer :organisation_id
      t.string :name
      t.string :street
      t.text :address
      t.string :postcode
      t.string :phone
      t.string :email
      t.date :started
      t.date :left
      t.string :ni_number

      t.timestamps
    end
  end

  def self.down
    drop_table :employees
  end
end
