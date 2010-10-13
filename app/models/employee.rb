class Employee < ActiveRecord::Base

  attr_accessible :name, :street, :address, :postcode,
                  :phone, :email, :ni_number, :started, :left

  belongs_to :organisation
  has_many :wages
  has_many :expenses
  has_many :wage_payments

  validates_presence_of :name, :street, :address, :postcode, :phone
#  validates_format_of :ni_number, :with => /^([a-z]|[A-Z]){2}(\d){6}([a-z]|[A-Z]){0,1}$/

end
