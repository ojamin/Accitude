class ReportsController < ApplicationController

  def unpaids
    invoices = @current_org.invoices.find_all_by_paid_on nil
    liabilities = @current_org.liabilities.find_all_by_paid_on nil
    ren_cont 'unpaids', {:invoices => invoices, :liabilities => liabilities}
  end

  def contacts
    # gets client list, for each client total invoices/liabilities paid/unpaid

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
