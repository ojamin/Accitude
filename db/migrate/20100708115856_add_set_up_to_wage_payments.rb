class AddSetUpToWagePayments < ActiveRecord::Migration
  def self.up
    add_column :wage_payments, :set_up, :boolean
  end

  def self.down
    remove_column :wage_payments, :set_up
  end
end
