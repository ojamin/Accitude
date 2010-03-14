class ReportsController < ApplicationController

  def unpaids
    invoices = @current_org.invoices.find_all_by_paid_on nil
    liabilities = @current_org.liabilities.find_all_by_paid_on nil
    ren_cont 'unpaids', {:invoices => invoices, :liabilities => liabilities}
  end

end
