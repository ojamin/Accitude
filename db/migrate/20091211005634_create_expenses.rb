class CreateExpenses < ActiveRecord::Migration
  def self.up
    create_table :expenses do |t|
      t.integer :employee_id
      t.date :claimed_on
      t.date :paid_on

      t.timestamps
    end
  end

  def self.down
    drop_table :expenses
  end
end
