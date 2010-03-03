class RenameInvoicesToAllInvoices < ActiveRecord::Migration
  def self.up
    rename_table :invoices, :all_invoices
  end

  def self.down
    rename_table :all_invoices, :invoices
  end
end
