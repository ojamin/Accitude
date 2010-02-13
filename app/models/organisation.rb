class Organisation < ActiveRecord::Base

  attr_accessible :period, :name, :address, :email,
                  :phone, :footer, :website

  has_and_belongs_to_many :users
  has_many :invoices
  has_many :quotes
  has_many :costs
  has_many :wages
  has_many :contacts
  has_many :employees
  has_many :payment_plans
  has_many :liabilities
  has_many :recurring_liabilities
  has_many :bank_accounts
  has_one :image

  #validates_presence_of :name, :address

end
