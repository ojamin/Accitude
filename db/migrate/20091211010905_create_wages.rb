class CreateWages < ActiveRecord::Migration
  def self.up
    create_table :wages do |t|
      t.integer :employee_id
      t.integer :organisation_id
      t.float :hourly_rate
      t.float :weekly_hours
      t.string :state
      t.date :start
      t.date :end
      t.string :tax_code
      t.float :other_deduction
      t.string :other_deduction_desc

      t.timestamps
    end
  end

  def self.down
    drop_table :wages
  end
end
