class EmployeesController < ApplicationController

  private
  def menu_items
    return [
      ['List Employees', {:url => {:action => :index}}],
      ['Add Employee', {:url => {:action => :new}}],
			['Wages', {:url => {:action => :wages}}],
			['Run Payroll', {:url => {:action => :run_payroll}}],
			['Wage Payments', {:url => {:action => :payment_index}}]
		]
  end

  public

	def wages
#		@current_org.employees.each do |e|
#			unless e.wages.first
#				(@wage = Wage.new).employee = e
#				@wage.save
#			end
#		end
		wages = []
		emps = @current_org.employees.all
		emps.each do |e|
 			e.wages.each do |w|
				wages << w
			end
		end
		wages.each do |wage|
			set_state_for(wage)
		end

		ren_cont 'wages', {:employees => @current_org.employees.paginate(:page => (params[:page] || '1'))} and return
	end

	def wage_view
		enforce_this(params[:id] && (@wage = Wage.find_by_id(params[:id])) && (@wage.employee = @current_org.employees.find_by_id(@wage.employee.id)))
		# @wage = @employee.wages.find :last
#		if @wage.is_active?
	  ren_cont 'wage_view', {:wage => @wage} and return
#		else 
#			ren_cont 'wage_edit', {:wage => @employee.wages.new} and return
#		end
	end

	def set_state_for(wage)

		# < means before, > means after
		wage.update_attribute(:state, "Current")
		if  wage.end && wage.end < Date.today
			wage.update_attribute(:state, "Ended")
		end

	end


	def wage_edit
		unless params[:new]
			enforce_this(params[:id] && (@wage = @current_org.wages.find_by_id(params[:id])))
		else
			enforce_this(params[:id] && (@employee = @current_org.employees.find_by_id(params[:id])))
			@wage = Wage.new
			@wage.employee_id = @employee.id
		 	@wage.organisation_id = @current_org.id	
		end	

		# < means before, > means after
		if params[:commit]
			if @wage.update_attributes(params[:wage])
				set_state_for @wage
				ren_cont 'wages', {:employees => @current_org.employees.paginate(:page => (params[:page] || '1'))} and return
				flash[:notice] = "Wage updated!"
			else
				flash[:error] = get_error_msgs @wage 
				#ren_cont 'wage_edit', {:id => @employee.id} and return
			end
#			ren_cont 'wages', {:employees => @current_org.employees.paginate(:page => (params[:page] || '1'))} and return
		end
		ren_cont 'wage_edit', {:wage => @wage} and return
			#{:id => @wage.id} and return
	end

	def run_payroll
		enforce_this(@wages = @current_org.wages)
		ren_cont 'run_payroll' and return
	end

	def payment_index
		ren_cont 'payment_index', {:payments => @current_org.wage_payments.all} and return
	end

	def payment_view
		ren_cont 'payment_view' and return
	end

	def payment_edit
		enforce_this(params[:id] && @payment = @current_org.wage_payments.find_by_id(params[:id]))
		if params[:commit]
#			@payment.for_ni = params[:wage_payment][:for_ni]
			if @payment.update_attributes(params[:wage_payment]) && @payment.update_attribute(:set_up, true)
				@payment.update_attribute(:for_employee, (@payment.total - @payment.for_income_tax - @payment.for_ni - @payment.for_other))
				flash[:notice] = "payment updated"
				ren_cont 'payment_index', {:payments => @current_org.wage_payments.all} and return
				else
				flash[:error] = get_error_msgs @payment
			end
		end
		ren_cont 'payment_edit' and return
	end

  def ex_index
    enforce_this(params[:id] && (@employee = @current_org.employees.find_by_id(params[:id])))
    ren_cont 'ex_index', {:employee => @employee} and return
  end

  def ex_new
    ex_edit
  end

  def ex_edit
    enforce_this (params[:id] && (@employee = @current_org.employees.find_by_id(params[:id])))
    (@expense = Expense.new).employee = @employee unless params[:eid] && (@expense = Expense.find_by_id(params[:eid]))
    if params[:commit]
      @expense.update_attributes params[:expense]
      if @expense.save
        insert_items params[:item_ids], @expense
        ren_cont 'ex_view', {:employee => @employee, :expense => @expense} and return
      else
        flash[:error] = get_error_msgs @expense
      end
    end
    ren_cont 'ex_edit', {:employee => @employee, :expense => @expense} and return
  end

  def ex_view
    enforce_this (params[:exp] && params[:id] &&
                  (@employee = @current_org.employees.find_by_id(params[:id])) &&
                  (@expense = @employee.expenses.find_by_id(params[:exp])))
    if params[:commit] && params[:paid_on] && ! @expense.paid_on && params[:paid_on].to_date >= @expense.claimed_on
      @expense.paid_on = params[:paid_on].to_date
      @expense.savec
      flash[:notice] = "Expense marked as paid!"
    end
    ren_cont 'ex_view', {:employee => @employee, :expense => @expense} and return
  end

  def index
    ren_cont 'index', {:employees => @current_org.employees.paginate(:page => (params[:page] || '1'))} and return
  end

  def view
    enforce_this (params[:id] && (@employee = @current_org.employees.find_by_id(params[:id].to_s)))
    ren_cont 'view', {:employee => @employee} and return
  end

  def new
    edit
 		@wage = @employee.wages.new.save
 	end

  def edit
    (@employee = Employee.new).organisation = @current_org unless params[:id] && (@employee = @current_org.employees.find_by_id(params[:id]))
    if params[:commit]
      @employee.update_attributes params[:employee]
      if @employee.save
        flash[:notice] = (params[:action] == 'new' ? 'Employee created!' : 'Employee updated!')
        ren_cont 'view', {:employee => @employee} and return
      else
        flash[:error] = get_error_msgs @employee
      end
    end
    ren_cont 'edit', {:employee => @employee} and return
  end
end
