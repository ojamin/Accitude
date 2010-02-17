class BankAccount < ActiveRecord::Base

  attr_accessible :name, :account, :sortcode, :publish

  belongs_to :organisation
  has_many :transactions
  
  validates_presence_of :name
  validates_length_of :account, :is => 8
  validates_format_of :sortcode, :with => /^(\d){2}-(\d){2}-(\d){2}$/, :message => 'should be in XX-XX-XX format'
end
