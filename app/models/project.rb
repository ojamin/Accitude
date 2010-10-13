class Project < ActiveRecord::Base

  belongs_to :organisation

  has_many :expenses
  has_many :invoices
  has_many :liabilities
  has_many :payment_plans
  has_many :quotes
  has_many :transactions

  validates_presence_of :name, :message => "You must include a name"
  validates_uniqueness_of :name
  validates_length_of :desc, :maximum => 1000, :message => "Description can't be more than 1000 letters"

end
