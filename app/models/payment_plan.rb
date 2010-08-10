class PaymentPlan < ActiveRecord::Base

  attr_accessible :start, :times, :last_run_on, :frequency, :project_id

	belongs_to :project
	belongs_to :contact
  belongs_to :organisation
  has_many :invoices
  has_many :items
  
  validates_presence_of :start
  validates_numericality_of :times, :greater_than_or_equal_to => -1, :only_integer => true
  
  #protected
  #  def validate
  #   if errors.invalid?(:times) == false
  #      errors.add(:times, "cannot be zero" ) if times == 0
  #    end
  #  end


  FREQS = ['Daily', 'Weekly', 'Monthly', 'Quarterly', 'Yearly']

  def self.freqs
    return FREQS
  end

  def get_freq
    freq = self.frequency.downcase
    return :day if freq == 'daily'
    return freq[0..-3].to_sym 
  end

  def freq_to_date
    freq = self.get_freq
    return 3.months if freq == :quarter
    return 1.send(freq)
  end

  def get_total
    return self.items.collect{|i| ((i.value || 0) * (i.quantity || 0))}.sum
  end

  def is_active?
    return true if self.start && self.start <= Date.today && (self.times > 0 || self.times == -1)
    return false
  end
  
  def needs_processing?
    return false unless self.is_active? &&
        (
          self.last_run_on == nil ||
          (self.last_run_on + self.freq_to_date) <= Date.today
        )
    return true
  end

  def process_plan
    invoices = []
    while self.needs_processing?
      inv = Invoice.new
      inv.produced_on = self.last_run_on ? (self.last_run_on + self.freq_to_date) : self.start
			inv.project_id = self.project_id
			inv.due_on = inv.produced_on + 1.month
      inv.contact = self.contact
 			inv.organisation = self.organisation
      inv.payment_plan = self
      inv.save
      self.items.each {|i|
        item = i.clone
        item.payment_plan = nil
        item.invoice = inv
        item.save
      }
      self.last_run_on = inv.produced_on
      self.save
      invoices << inv
    end
    return invoices
  end
	
	

end
