class ReportsController < ApplicationController

  def index
    # from overview
    #	incoming_paid = 0
    #	outgoing_paid = 0
    #	outgoing_unpaid = 0 # people who i owe cash to
    #	incoming_unpaid = 0 # people who owe me cash
    #	@current_org.invoices.each {|i| i.paid_on ? (incoming_paid += i.total_value) : (incoming_unpaid += i.total_value)}
    #	@current_org.liabilities.each {|l| l.paid_on ? (outgoing_paid += l.value) : (outgoing_unpaid += l.value)} 
    ren_cont 'index'
  end

  def overview
    incoming_paid = 0
    outgoing_paid = 0
    outgoing_unpaid = 0 # people who i owe cash to
    incoming_unpaid = 0 # people who owe me cash
    @current_org.invoices.each {|i| i.paid_on ? (incoming_paid += i.total_value) : (incoming_unpaid += i.total_value)}
    @current_org.liabilities.each {|l| l.paid_on ? (outgoing_paid += l.value) : (outgoing_unpaid += l.value)}


    ren_cont 'overview', {:incoming_paid => incoming_paid, :incoming_unpaid => incoming_unpaid, :outgoing_paid => outgoing_paid, :outgoing_unpaid => outgoing_unpaid}
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

  def profit_and_loss
    after = params["after"].to_date unless params["after"].nil?
	before = params["before"].to_date unless params["before"].nil?
    @start_date = after || Date.today - 1.year
	@end_date = before || Date.today
    @income = @current_org.invoices.find(:all, :conditions => ("paid_on IS NOT NULL AND paid_on BETWEEN '#{@start_date}' AND '#{@end_date}'"))
	@expenses = @current_org.liabilities(:all, :conditions => ("paid_on IS NOT NULL AND paid_on BETWEEN '#{@start_date}' AND '#{@end_date}'"))
	@total_income = @income.collect{|i| i.total_value}.sum
	@total_expense = @expenses.collect{|l| l.value}.sum
	@profit_or_loss = @total_income - @total_expense
	ren_cont 'profit_loss'
  end

end
