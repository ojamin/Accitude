class AllLiability < ActiveRecord::Base

  attr_accessible :incurred_on, :paid_on, :description,
                  :receipt_id, :processed, :value

  belongs_to :contact
  belongs_to :organisation
  has_many :transactions

  validates_presence_of :description
  validates_numericality_of :value, :greater_than_or_equal_to => 0.01

  def been_paid?
    return true if paid_on
    return false
  end

end
