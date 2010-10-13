class AddEmployeeIdToWagePayment < ActiveRecord::Migration
  def self.up
    add_column :wage_payments, :employee_id, :integer
  end

  def self.down
    remove_column :wage_payments, :employee_id
  end
end
