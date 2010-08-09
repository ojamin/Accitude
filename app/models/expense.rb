class Expense < AllExpense

	belongs_to :organisation
	belongs_to :project
  belongs_to :employee
  has_many :transactions
  has_many :items

end
