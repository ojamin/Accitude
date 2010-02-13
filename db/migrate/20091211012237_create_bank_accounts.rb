class CreateBankAccounts < ActiveRecord::Migration
  def self.up
    create_table :bank_accounts do |t|
      t.integer :organisation_id
      t.string :name
      t.string :account
      t.string :sortcode
      t.boolean :publish

      t.timestamps
    end
  end

  def self.down
    drop_table :bank_accounts
  end
end
