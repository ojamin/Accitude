class InvoiceProcessedNotNull < ActiveRecord::Migration
  def self.up
    AllInvoice.find(:all).each {|i|
      i[:type] = "Invoice"
      i.processed = false
      i.save
    }
    change_column_default :all_invoices, :processed, false
    change_column :all_invoices, :processed, :boolean, :null => false
  end

  def self.down
    change_column :all_invoices, :processed, :boolean, {:null => true, :default => nil}
  end
end
