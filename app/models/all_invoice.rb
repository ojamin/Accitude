class AllInvoice < ActiveRecord::Base

  attr_accessible :produced_on, :due_on, :paid_on,
                  :paid_method, :processed
  
  belongs_to :quote
  belongs_to :payment_plan
  belongs_to :contact
  belongs_to :organisation
  has_many :items, :foreign_key => :invoice_id
  has_many :recordeds, :foreign_key => :invoice_id
  has_many :transactions, :foreign_key => :invoice_id

  validates_presence_of :produced_on

  def been_paid?
    return true if paid_on
    return false
  end

  def total_value
    val = 0
    self.items.each do |i|
      val += i.value if i.value
    end
    return val
  end

end
