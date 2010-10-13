class Wage < ActiveRecord::Base

  attr_accessible :hourly_rate, :weekly_hours, :state,
                  :start, :end, :tax_code, :other_deduction
                  :other_deduction_desc
  validates_presence_of :start
  validates_numericality_of :hourly_rate, :weekly_hours

  belongs_to :employee
  belongs_to :organisation
  has_many :wage_payments

  STATES = ['Pending', 'Current', 'Ended']

  def self.states
    return STATES
  end

#  def get_freq
#    freq = self.frequency.downcase
#    return freq[0..-3].to_sym
#  end

#  def freq_to_date
#    freq = self.get_freq
#    return 1.send(freq)
#  end

  def is_active?
    return false unless self.state = "Current"
    return true
  end

  def needs_processing?
#    self.get_freq
    return false unless self.is_active? &&
      self.start <= Date.today &&
      (
        self.last_processed_at == nil ||
        self.last_processed_at <= (Date.today - (Date.today.day - 1).days)
       )  
    return true
  end

  def run_payroll  #Equivalent to Process plan in the payment_plan model.
    payments = []
    while self.needs_processing?
      paym = WagePayment.new
      paym.employee_id = self.employee.id
      paym.organisation_id = self.organisation.id
      paym.total = self.hourly_rate * self.weekly_hours * 4
      paym.wage_id = self.id
      
      paym.for_ni = 0
      paym.for_income_tax = 0
      paym.for_other = 0 

      paym.save
      # paym.for_income_tax = paym.total * 0.00 #not sure
      # paym.for_ni = paym.total * 0.00 # should these two be part of the employee entry (as %)?
      # prev = self.wage_payment.last
        # won't work, would include all payments

#      prev = self.WagePayments.find :last

      self.last_processed_at = Date.today
      self.save
    payments << paym
    end
    return payments
  end



end
