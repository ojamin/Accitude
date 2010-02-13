class DecimaliseValues < ActiveRecord::Migration
  def self.up
    change_column :items, :value, :decimal, :precision => 10, :scale => 2

    change_column :liabilities, :value, :decimal, :precision => 10, :scale => 2

    rename_column :transactions, :amount, :value
    change_column :transactions, :value, :decimal, :precision => 10, :scale => 2

    change_column :wage_payments, :for_employee, :decimal, :precision => 10, :scale => 2
    change_column :wage_payments, :for_income_tax, :decimal, :precision => 10, :scale => 2
    change_column :wage_payments, :for_ni, :decimal, :precision => 10, :scale => 2
    change_column :wage_payments, :for_other, :decimal, :precision => 10, :scale => 2
    change_column :wage_payments, :total, :decimal, :precision => 10, :scale => 2
    change_column :wage_payments, :hours, :decimal, :precision => 10, :scale => 2

    change_column :wages, :hourly_rate, :decimal, :precision => 10, :scale => 2
    change_column :wages, :weekly_hours, :decimal, :precision => 10, :scale => 2
    change_column :wages, :other_deduction, :decimal, :precision => 10, :scale => 2
  end

  def self.down
    change_column :wages, :other_deduction, :float
    change_column :wages, :weekly_hours, :float
    change_column :wages, :hourly_rate, :float

    change_column :wage_payments, :hours, :float
    change_column :wage_payments, :total, :float
    change_column :wage_payments, :for_other, :float
    change_column :wage_payments, :for_ni, :float
    change_column :wage_payments, :for_income_tax, :float
    change_column :wage_payments, :for_employee, :float

    change_column :transactions, :value, :float
    rename_column :transactions, :value, :amount

    change_column :liabilities, :value, :float

    change_column :items, :value, :float
  end
end
