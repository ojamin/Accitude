class FixInvoices < ActiveRecord::Migration
  def self.up
    AllInvoice.find(:all).each {|i|
      i[:type] = "Invoice"
      i.save
    }
  end

  def self.down
  end
end
