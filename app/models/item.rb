class Item < ActiveRecord::Base

  attr_accessible :desc, :value, :quantity

  belongs_to :payment_plan
  belongs_to :quote
  belongs_to :invoice
  belongs_to :expense

  def has_relationship?
    return false unless self.payment_plan_id || self.quote_id || self.invoice_id || self.expense
    return true
  end

  #validates_presence_of :desc
  #validates_numericality_of :value
  #validates_numericality_of :quantity :only_integer => true

end
