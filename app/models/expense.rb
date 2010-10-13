class Expense < AllExpense

  attr_accessible :project_id

  
  belongs_to :organisation
  belongs_to :project
  belongs_to :employee
  has_many :transactions
  has_many :items
  has_many :images

end
