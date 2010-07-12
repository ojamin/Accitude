class WagePayment < ActiveRecord::Base

  attr_accessible :for_employee, :for_income_tax, :for_ni,
                  :for_other, :for_other_desc, :total, :hours,
                  :period_start, :period_end, :paid_on, :payment_method

	validates_numericality_of :for_ni, :for_income_tax, :for_other, :total

	belongs_to :employee
	belongs_to :wage
	belongs_to :organisation
	has_many :transactions

end
