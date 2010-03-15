class ReportsController < ApplicationController

  def overview
    incomming = 0
    outgoing = 0
    creditors = 0 # people who i owe cash to 
    debitors = 0 # people who owe me cash
    @current_org.invoices.each {|i| i.paid_on ? (incomming += i.total_value) : (debitors += i.total_value)}
    @current_org.liabilities.each {|l| l.paid_on ? (outgoing += l.value) : (creditors += l.value)}



  end

  def unpaids
    invoices = @current_org.invoices.find_all_by_paid_on nil
    liabilities = @current_org.liabilities.find_all_by_paid_on nil
    ren_cont 'unpaids', {:invoices => invoices, :liabilities => liabilities}
  end

  def contacts
    customers = {}
    suppliers = {}
    @current_org.contacts.each do |c|
      if c.customer
        customers[c.name_long] = [
          ["Total invoices", c.invoices.collect{|i| i.total_value}.sum],
          ["Unpaid invoices", c.invoices.collect{|i| i.paid_on ? 0 : i.total_value}.sum]
        ]
      end
      if c.supplier
        suppliers[c.name_long] = [
          ["Total liabilities", c.liabilities.collect{|l| l.value}.sum],
          ["Unpaid liabilities", c.liabilities.collect{|l| l.paid_on ? 0 : l.value}.sum]
        ]
      end
    end
    ren_cont 'contacts', {:customers => customers, :suppliers => suppliers}
  end

end
