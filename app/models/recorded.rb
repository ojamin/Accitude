class Recorded < ActiveRecord::Base

  attr_accessible :done_on, :type

  belongs_to :invoice

  TYPES = ['Sent', 'Cancelled']

end
