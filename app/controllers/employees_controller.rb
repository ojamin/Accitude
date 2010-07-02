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

	def wage_edit
		enforce_this (params[:id] && (@employee = @current_org.employees.find_by_id(params[:id])))
		@wage = @employee.wages.last
		# < means before, > means after
		if params[:commit]
			if @wage.start && @wage.end
			  if(@wage.start < Date.today) && (@wage.end < Date.today)
				  @wage.state = 'Ended'
				end
			elsif @wage.start && !@wage.end 
			  @wage.state = 'Current'
			elsif @wage.start && @wage.end
				if @wage.end > Date.today && @wage.start < Date.today
					@wage.state = 'Current'
				end
			end
		end
	  if @wage.update_attributes(params[:wage])
			ren_cont 'wage_view', {:wage => @wage} and return
		end
		ren_cont 'wage_edit', {:wage => @wage} and return
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
