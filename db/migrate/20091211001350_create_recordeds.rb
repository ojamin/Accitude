class CreateRecordeds < ActiveRecord::Migration
  def self.up
    create_table :recordeds do |t|
      t.date :done_on
      t.string :type
      t.integer :invoice_id

      t.timestamps
    end
  end

  def self.down
    drop_table :recordeds
  end
end
