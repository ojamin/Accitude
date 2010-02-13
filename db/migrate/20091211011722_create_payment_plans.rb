class CreatePaymentPlans < ActiveRecord::Migration
  def self.up
    create_table :payment_plans do |t|
      t.integer :contact_id
      t.integer :organisation_id
      t.date :start
      t.integer :times
      t.date :last_run_on
      t.string :frequency

      t.timestamps
    end
  end

  def self.down
    drop_table :payment_plans
  end
end
