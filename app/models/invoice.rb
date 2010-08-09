class Invoice < AllInvoice

	belongs_to :project
  belongs_to :quote
  belongs_to :payment_plan
  belongs_to :contact
	belongs_to :organisation
	has_many :items, :foreign_key => :invoice_id
  has_many :recordeds, :foreign_key => :invoice_id
  has_many :transactions, :foreign_key => :invoice_id

end
