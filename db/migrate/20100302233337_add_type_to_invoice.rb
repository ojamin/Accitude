class AddTypeToInvoice < ActiveRecord::Migration
  def self.up
    add_column :invoices, :type, :string
    inv = Invoices.find :all
    inv.each {|i|
      i[:type] = "Invoice"
      i.save
    }
  end

  def self.down
    remove_column :invoices, :type
  end
end
