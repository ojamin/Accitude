class CreateInvoices < ActiveRecord::Migration
  def self.up
    create_table :invoices do |t|
      t.date :produced_on
      t.date :due_on
      t.date :paid_on
      t.string :paid_method
      t.integer :quote_id
      t.integer :payment_plan_id
      t.integer :contact_id
      t.integer :organisation_id
      t.boolean :processed

      t.timestamps
    end
  end

  def self.down
    drop_table :invoices
  end
end
