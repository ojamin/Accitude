class RecurringLiability < ActiveRecord::Base

  attr_accessible :information, :start, :times,
                  :last_run_on, :frequency

  belongs_to :contact
  belongs_to :organisation
  has_many :items
  has_many :liabilities

end
