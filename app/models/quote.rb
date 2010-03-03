class Quote < ActiveRecord::Base

  attr_accessible :produced_on, :valid_till

  belongs_to :contact
  belongs_to :organisation
  has_many :items
  has_many :invoices, :class_name => "AllInvoice"

  validates_presence_of :produced_on

end
