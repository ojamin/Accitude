class Wage < ActiveRecord::Base

  attr_accessible :hourly_rate, :weekly_hours, :state,
                  :start, :end, :tax_code, :other_deduction
                  :other_deduction_desc

  belongs_to :employee
  belongs_to :organisation
  has_many :wage_payments

	STATES = ['Pending', 'Current', 'Ended']

	def self.states
		return STATES
	end

# First try stuff

#	def needs_processing?
#		mon = self.wage_payments.count + 1
#		return true if
#			Day.today == (self.created_at + mon.months) 
#			# alternatively, The first of the month?
#			# Day.today.month >= (self.created_at.month + mon.months)
#		return false
#	end

#	def process_plan
#		wage_payments = [] 
#		while self.needs_processing?
#			paym = Wage_payment
#			paym.
#		end
#	end

	FREQS = ['Weekly', 'Monthly']

	def self.freqs
		return FREQS
	end

	def get_freq
		freq = self.frequency.downcase
		return freq[0..-3].to_sym
	end

	def freq_to_date
		freq = self.get_freq
		return 1.send(freq)
	end

	def is_active?
		return false unless self.state = "Current"
		return true
	end

	def needs_processing?
		self.get_freq
		return false unless self.is_active? &&
			Time.now <= (self.start + (self.wage_payments.count + 1)).freq
		return true
	end

	def run_payroll  #Equivalent to Process plan in the payment_plan model.
		payments = []
		while self.needs_processing?
			paym = WagePayment.new
			paym.employee_id = self.employee.id
			if freq == :weekly
				paym.hours = self.weekly_hours
			else
				paym.hours = self.weekly_hours * 4
			end
			paym.total = self. hourly_rate * weekly_hours
			# paym.for_income_tax = paym.total * 0.00 #not sure
			# paym.for_ni = paym.total * 0.00 # should these two be part of the employee entry (as %)?
			# prev = WagePayment.find_by_id(paym.id -1)
				# won't work, would include all payments
			prev = self.WagePayments.find :last
			if prev
				paym.period_start = prev.period_end
			else
				paym.period_start = self.created_at.to_date	
			end
			paym.period_end = Date.today

		end
	end



end
