class Expense < ActiveRecord::Base

  attr_accessible :claimed_on, :paid_on, :notes

  belongs_to :employee
  has_many :transactions
  has_many :items

  def get_total
    return self.items.collect{|i| ((i.value || 0) * (i.quantity || 0))}.sum
  end

  validates_presence_of :claimed_on

end
