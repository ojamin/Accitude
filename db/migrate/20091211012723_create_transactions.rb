class CreateTransactions < ActiveRecord::Migration
  def self.up
    create_table :transactions do |t|
      t.integer :expense_id
      t.integer :wage_payment_id
      t.integer :liability_id
      t.integer :contact_id
      t.integer :bank_account_id
      t.integer :invoice_id
      t.date :posted_on
      t.string :type
      t.string :desc
      t.float :amount
      t.string :kind

      t.timestamps
    end
  end

  def self.down
    drop_table :transactions
  end
end
