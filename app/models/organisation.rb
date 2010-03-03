class Organisation < ActiveRecord::Base

  attr_accessible :period, :name, :address, :email,
                  :phone, :footer, :website

  has_and_belongs_to_many :users
  has_many :invoices, :class_name => "AllInvoice"
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

  validates_presence_of :name
  validates_uniqueness_of :name
  #validates_format_of :image_url, :with    => %r{\.(gif|jpg|png)$}i, :message => "must be a URL for a GIF, JPG, or PNG image"


  def customers
    return self.contacts.find_all_by_customer(true)
  end

  def suppliers
    return self.contacts.find_all_by_supplier(true)
  end
end
