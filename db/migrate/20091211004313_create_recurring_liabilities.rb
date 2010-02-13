class CreateRecurringLiabilities < ActiveRecord::Migration
  def self.up
    create_table :recurring_liabilities do |t|
      t.integer :contact_id
      t.integer :organisation_id
      t.text :information
      t.date :start
      t.integer :times
      t.date :last_run_on
      t.string :frequency

      t.timestamps
    end
  end

  def self.down
    drop_table :recurring_liabilities
  end
end
