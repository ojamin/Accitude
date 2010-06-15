# This file is auto-generated from the current state of the database. Instead of editing this file, 
# please use the migrations feature of Active Record to incrementally modify your database, and
# then regenerate this schema definition.
#
# Note that this schema.rb definition is the authoritative source for your database schema. If you need
# to create the application database on another system, you should be using db:schema:load, not running
# all the migrations from scratch. The latter is a flawed and unsustainable approach (the more migrations
# you'll amass, the slower it'll run and the greater likelihood for issues).
#
# It's strongly recommended to check this file into your version control system.

ActiveRecord::Schema.define(:version => 20100615140349) do

  create_table "all_expenses", :force => true do |t|
    t.integer  "employee_id"
    t.date     "claimed_on"
    t.date     "paid_on"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.text     "notes"
    t.string   "type"
  end

  create_table "all_invoices", :force => true do |t|
    t.date     "produced_on"
    t.date     "due_on"
    t.date     "paid_on"
    t.string   "paid_method"
    t.integer  "quote_id"
    t.integer  "payment_plan_id"
    t.integer  "contact_id"
    t.integer  "organisation_id"
    t.boolean  "processed",       :default => false, :null => false
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "type"
  end

  create_table "all_liabilities", :force => true do |t|
    t.integer  "contact_id"
    t.integer  "organisation_id"
    t.date     "incurred_on"
    t.date     "paid_on"
    t.text     "description"
    t.string   "receipt_id"
    t.boolean  "processed"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.decimal  "value"
    t.string   "type"
  end

  create_table "bank_accounts", :force => true do |t|
    t.integer  "organisation_id"
    t.string   "name"
    t.string   "account"
    t.string   "sortcode"
    t.boolean  "publish"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "contacts", :force => true do |t|
    t.integer  "quote_id"
    t.integer  "invoice_id"
    t.integer  "organisation_id"
    t.string   "company"
    t.string   "name"
    t.string   "street"
    t.text     "address"
    t.string   "postcode"
    t.string   "phone"
    t.string   "fax"
    t.string   "email"
    t.boolean  "customer"
    t.boolean  "supplier"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "website"
    t.string   "phone2"
  end

  create_table "employees", :force => true do |t|
    t.integer  "organisation_id"
    t.string   "name"
    t.string   "street"
    t.text     "address"
    t.string   "postcode"
    t.string   "phone"
    t.string   "email"
    t.date     "started"
    t.date     "left"
    t.string   "ni_number"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "images", :force => true do |t|
    t.integer  "size"
    t.string   "content_type"
    t.string   "filename"
    t.integer  "height"
    t.integer  "width"
    t.integer  "parent_id"
    t.string   "thumbnail"
    t.integer  "organisation_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "items", :force => true do |t|
    t.integer  "payment_plan_id"
    t.integer  "quote_id"
    t.integer  "invoice_id"
    t.integer  "expense_id"
    t.string   "desc"
    t.decimal  "value"
    t.float    "quantity"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "organisations", :force => true do |t|
    t.date     "period"
    t.string   "name"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.text     "address"
    t.string   "email"
    t.string   "phone"
    t.text     "footer"
    t.string   "website"
  end

  create_table "organisations_users", :id => false, :force => true do |t|
    t.integer "organisation_id"
    t.integer "user_id"
  end

  create_table "payment_plans", :force => true do |t|
    t.integer  "contact_id"
    t.integer  "organisation_id"
    t.date     "start"
    t.integer  "times"
    t.date     "last_run_on"
    t.string   "frequency"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "quotes", :force => true do |t|
    t.integer  "contact_id"
    t.integer  "organisation_id"
    t.date     "produced_on"
    t.date     "valid_till"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "recordeds", :force => true do |t|
    t.date     "done_on"
    t.string   "type"
    t.integer  "invoice_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "recurring_liabilities", :force => true do |t|
    t.integer  "contact_id"
    t.integer  "organisation_id"
    t.text     "information"
    t.date     "start"
    t.integer  "times"
    t.date     "last_run_on"
    t.string   "frequency"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "sessions", :force => true do |t|
    t.string   "session_id", :null => false
    t.text     "data"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "sessions", ["session_id"], :name => "index_sessions_on_session_id"
  add_index "sessions", ["updated_at"], :name => "index_sessions_on_updated_at"

  create_table "transactions", :force => true do |t|
    t.integer  "expense_id"
    t.integer  "wage_payment_id"
    t.integer  "liability_id"
    t.integer  "contact_id"
    t.integer  "bank_account_id"
    t.integer  "invoice_id"
    t.date     "posted_on"
    t.string   "type"
    t.string   "desc"
    t.decimal  "value"
    t.string   "kind"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "users", :force => true do |t|
    t.string   "username"
    t.string   "password"
    t.string   "email"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "wage_payments", :force => true do |t|
    t.integer  "wage_id"
    t.decimal  "for_employee"
    t.decimal  "for_income_tax"
    t.decimal  "for_ni"
    t.decimal  "for_other"
    t.string   "for_other_desc"
    t.decimal  "total"
    t.decimal  "hours"
    t.date     "period_start"
    t.date     "period_end"
    t.date     "paid_on"
    t.string   "payment_method"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "employee_id"
  end

  create_table "wages", :force => true do |t|
    t.integer  "employee_id"
    t.integer  "organisation_id"
    t.decimal  "hourly_rate"
    t.decimal  "weekly_hours"
    t.string   "state"
    t.date     "start"
    t.date     "end"
    t.string   "tax_code"
    t.decimal  "other_deduction"
    t.string   "other_deduction_desc"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "wiki_items", :force => true do |t|
    t.string   "name"
    t.text     "content"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

end
