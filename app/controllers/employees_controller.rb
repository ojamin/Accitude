class EmployeesController < ApplicationController

  private
  def menu_items
    return [
      ['List Employees', {:url => {:action => :index}}],
      ['Add Employee', {:url => {:action => :new}}],
			['Wages', {:url => {:action => :wages}}],
			['Run Payroll', {:url => {:action => :run_payroll}}]
    ]
  end

  public

	def wages
		#ren_cont 'wages', {:employees => @current_org.employees.paginate(:page => (params[:page] || '1'))} and return

		@current_org.employees.each do |e|
			unless e.wages.first
				(@wage = Wage.new).employee = e
				@wage.save
			end
		end

		wages = []
		emps = @current_org.employees.all
		emps.each do |e|
			e.wages.each do |w|
				wages << w
			end
		end
	
		wages.each do |w|
			set_state_for w
		end

		ren_cont 'wages', {:employees => @current_org.employees.paginate(:page => (params[:page] || '1'))} and return
	end

	def wage_view
		enforce_this(params[:id] && (@employee = @current_org.employees.find_by_id(params[:id])))
		@wage = @employee.wages.find :last
		if @wage.is_active?
	  	ren_cont 'wage_view', {:wage => @wage} and return
		else 
			ren_cont 'wage_edit', {:wage => @employee.wages.new} and return
		end
	end

	def set_state_for(wage)
		# < means before, > means after
		if wage.start && wage.end
			if (wage.start < Date.today) && (wage.end < Date.today)
				wage.update_attributes(:state, "Ended")
			end
		elsif wage.start && !wage.end
			if wage.start < Date.today
				wage.update_attribute(:state, "Current")
			end
		elsif wage.start && wage.end
			if wage.end > Date.today && wage.start < Date.today
				wage.update_attribute(:state, "Current")
			end
		end
	end


	def wage_edit
		enforce_this (params[:id] && (@employee = @current_org.employees.find_by_id(params[:id])))
	  if @employee.wages.last && @employee.wages.last.state == "Current" 
			@wage = @employee.wages.last
			@edit = 'true'
		else
			(@wage = Wage.new).employee = @employee
      @edit = 'false'
		end	
		# < means before, > means after
		if params[:commit]
			if @wage.update_attributes(params[:wage])
				set_state_for @wage
#				if @wage.start && @wage.end
#				  if(@wage.start < Date.today) && (@wage.end < Date.today)
#					  #@wage.state = 'Ended'
#						@wage.update_attribute(:state, "Ended")
#					end
#				elsif @wage.start && !@wage.end 
#				  #@wage.state = 'Current'
#					@wage.update_attribute(:state, "Current")
#				elsif @wage.start && @wage.end
#					if @wage.end > Date.today && @wage.start < Date.today
#						#@wage.state = 'Current'
#						@wage.update_attribute(:state, "Current")
#					end
#				end

			else
				flash[:error] = get_error_msgs @wage 
				ren_cont 'wage_edit', {:id => @employee.id} and return
			end
			ren_cont 'wages', {:employees => @current_org.employees.paginate(:page => (params[:page] || '1'))} and return
		end
		ren_cont 'wage_edit', {:id => @employee.id} and return
	end

	def run_payroll

	end


  def ex_index
    enforce_this (params[:id] && (@employee = @current_org.employees.find_by_id(params[:id])))
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
