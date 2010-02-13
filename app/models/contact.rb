class Contact < ActiveRecord::Base

  attr_accessible :company, :name, :street, :address,
                  :postcode, :phone, :fax, :email

  belongs_to :quote
  belongs_to :integer
  belongs_to :organisation
  has_many :costs
  has_many :quotes
  has_many :invoices
  has_many :transactions
  has_many :recurring_liabilities
  has_many :payment_plans

  def name_long
    outp = []
    outp << self.name if self.name
    outp << self.company if self.company
    return (outp.join ', ' || 'No contact name')
  end

  validates_presence_of  :name, :company, :street
  
end
