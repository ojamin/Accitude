class Wage < ActiveRecord::Base

  attr_accessible :hourly_rate, :weekly_hours, :state,
                  :start, :end, :tax_code, :other_deduction
                  :other_deduction_desc

  belongs_to :employee
  belongs_to :organisation
  has_many :wage_payments

  STATES = ['Pending', 'Current', 'Ended']
  
end
