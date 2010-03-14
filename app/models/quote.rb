class Quote < ActiveRecord::Base

  attr_accessible :produced_on, :valid_till

  belongs_to :contact
  belongs_to :organisation
  has_many :items
  has_many :invoices

  validates_presence_of :produced_on

  def total_value
    val = 0
    self.items.each do |i|
      val += i.value if i.value
    end
    return val
  end

end
