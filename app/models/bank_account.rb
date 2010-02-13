class BankAccount < ActiveRecord::Base

  attr_accessible :name, :account, :sortcode, :publish

  belongs_to :organisation
  has_many :transactions
  
  validates_presence_of :name
  validates_length_of :sortcode, :minimum => 6
  validates_length_of :account, :is => 8
end
