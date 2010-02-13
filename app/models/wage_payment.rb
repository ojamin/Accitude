class WagePayment < ActiveRecord::Base

  attr_accessible :for_employee, :for_income_tax, :for_ni,
                  :for_other, :for_other_desc, :total, :hours,
                  :period_start, :period_end, :paid_on, :payment_method

  belongs_to :wage_id
  has_many :transactions

end
