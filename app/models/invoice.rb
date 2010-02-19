class Invoice < ActiveRecord::Base

  attr_accessible :produced_on, :due_on, :paid_on,
                  :paid_method, :processed
  
  belongs_to :quote
  belongs_to :payment_plan
  belongs_to :contact
  belongs_to :organisation
  has_many :items
  has_many :recordeds
  has_many :transactions

  validates_presence_of :produced_on

  def been_paid?
    return true if paid_on
    return false
  end
end
