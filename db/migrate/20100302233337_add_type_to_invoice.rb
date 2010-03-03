class AddTypeToInvoice < ActiveRecord::Migration
  def self.up
    add_column :invoices, :type, :string
    Invoice.reset_column_information
    Invoice.find(:all).each {|i|
      i[:type] = "Invoice"
      i.save
    }
  end

  def self.down
    remove_column :invoices, :type
  end
end
