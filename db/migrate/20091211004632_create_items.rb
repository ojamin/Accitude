class CreateItems < ActiveRecord::Migration
  def self.up
    create_table :items do |t|
      t.integer :payment_plan_id
      t.integer :quote_id
      t.integer :invoice_id
      t.integer :expense_id
      t.text :desc
      t.float :value
      t.float :quantity

      t.timestamps
    end
  end

  def self.down
    drop_table :items
  end
end
