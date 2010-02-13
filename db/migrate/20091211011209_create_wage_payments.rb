class CreateWagePayments < ActiveRecord::Migration
  def self.up
    create_table :wage_payments do |t|
      t.integer :wage_id
      t.float :for_employee
      t.float :for_income_tax
      t.float :for_ni
      t.float :for_other
      t.string :for_other_desc
      t.float :total
      t.float :hours
      t.date :period_start
      t.date :period_end
      t.date :paid_on
      t.string :payment_method

      t.timestamps
    end
  end

  def self.down
    drop_table :wage_payments
  end
end
