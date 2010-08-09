class Quote < ActiveRecord::Base

  attr_accessible :produced_on, :valid_till, :project_id

	belongs_to :project
	belongs_to :contact
  belongs_to :organisation
  has_many :items
  has_many :invoices

  validates_presence_of :produced_on

  def total_value
    return self.items.collect{|i| ((i.value || 0) * (i.quantity || 0))}.sum
  end

end
