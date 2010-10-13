class InvoicesController < ApplicationController

  private
  def menu_items
    return [
      ['List Invoices', {:url => {:action => :index}}],
      ['New Invoice', {:url => {:action => :new}}],
      ['Process Recurring', {:url => {:action => :rec_process}}],
      ['New Recurring', {:url => {:action => :rec_new}}],
      ['List Recurring', {:url => {:action => :rec_index}}]
    ]
  end

  public
  def index
    conditions = []
    conditionvalues = []

    #get values if present in the params, or set defaults
    if params[:contact] && @current_org.contacts.find_by_id(params[:contact].to_s)
      @contact = params[:contact].to_s
    else
      @contact = -1
    end
    @before = params[:before] ? Time.parse(params[:before]) : Time.now
    @after = params[:after] ? Time.parse(params[:after]) : 1.year.ago
    @procstate = ['Processed', 'Unprocessed', 'Paid', 'Unpaid'].include?(params[:procstate]) ? params[:procstate] : "All"
    
    #setup the conditions
    if @contact != -1
      conditions << "contact_id = ?"
      conditionvalues << @contact
    end
    conditions << "produced_on < ?"
    conditionvalues << @before
    conditions << "produced_on > ?"
    conditionvalues << @after
    if @procstate == "Processed"
      conditions << "processed = ?"
      conditionvalues << TRUE
    elsif @procstate == "Unprocessed"
      conditions << "processed = ?"
      conditionvalues << FALSE
    elsif @procstate == "Paid"
      conditions << "paid_on is not NULL"
    elsif @procstate == "Unpaid"
      conditions << "paid_on is NULL"
    end

    if conditions.length != 0
      if @current_project
        @invoices = @current_project.invoices.find(:all, :conditions => [conditions.join(' and '), *conditionvalues]).paginate :page => (params[:page] || '1')
      else
      @invoices = @current_org.invoices.find(:all, :conditions => [conditions.join(' and '), *conditionvalues]).paginate :page => (params[:page] || '1')
      end
    else
      if @current_project
        @invoices = @current_project.invoices.paginate :page => (params[:page] || '1')
      else
        @invoices = @current_org.invoices.paginate :page => (params[:page] || '1')
      end
    end
    @contacts = @current_org.customers


    ren_cont 'index', {:invoices => @invoices, :contacts => @contacts, :contact => @contact, :before => @before, :after => @after, :procstate => @procstate} and return
  end

  def new
    edit
  end

  def edit
    (@invoice = Invoice.new(:produced_on => Date.today, :due_on => (Date.today + 1.month))).organisation = @current_org unless (params[:id] && (@invoice = Invoice.find_by_id(params[:id])))
    enforce_this @invoice.been_paid? == false
    if params[:commit]
      @invoice.update_attributes params[:invoice]
      logger.info 'this one'


      if params[:contact_id]
        return unless (c = @current_org.contacts.find_by_id params[:contact_id])
        @invoice.contact = c
      end
      if @invoice.save
        logger.info 'invoice has been saved'
        insert_items params[:item_ids], @invoice
        ren_cont 'view', {:invoice => @invoice} and return
      else
        flash[:error] = get_error_msgs @invoice
      end
    end
    @contacts = @current_org.customers
    ren_cont 'edit', {:invoice => @invoice, :contacts => @contacts} and return
  end

  def view
    enforce_this params[:id] && (@invoice = @current_org.invoices.find_by_id(params[:id]))
    if params[:format] && params[:format] = 'pdf'
      @filename = "#{@current_org.name} invoice - #{@invoice.produced_on}"
      send_data render_to_string(:partial => 'view_pdf', :locals => {:invoice => @invoice}), :type => :pdf, :disposition => 'inline', :filename => "#{@filename}.pdf" and return
    end
    if params[:commit] && params[:paid_on] && ! @invoice.paid_on && params[:paid_on].to_date >= @invoice.produced_on
      @invoice.paid_on = params[:paid_on].to_date
      @invoice.save
      flash[:notice] = "Invoice marked as paid"

      t = Transaction.new
      t.ttype = 'Invoice'
      t.invoice_id = @invoice.id
      t.kind = 'Credit'
      t.desc = "Invoice: #{@invoice.contact.name}, #{@invoice.contact.company}"
      t.organisation_id = @current_org.id
      if @invoice.project
        t.project_id = @invoice.project_id
      end
      t.save  
      logger.info 'transaction script has been called'
          
    end
    ren_cont 'view', {:invoice => @invoice} and return
  end

  def remove
    enforce_this params[:id] && (@invoice = @current_org.invoices.find_by_id(params[:id])) && @invoice.been_paid? == false
    @invoice[:type] = "RemovedInvoice"
    @invoice.save
    flash[:notice] = "Invoice removed!"
    index
  end

  def rec_end
    enforce_this params[:id] && (@plan = @current_org.payment_plans.find_by_id(params[:id]))
    @plan.times = 0
    @plan.save
    ren_cont 'rec_view', {:plan => @plan} and return
  end

  def rec_index
    unless @current_project
      @plans = @current_org.payment_plans.paginate :page => (params[:page] || '1')
    else
      @plans = @current_project.payment_plans.paginate :page => (params[:page] || '1')  
    end
    ren_cont 'rec_index', {:plans => @plans} and return
  end

  def rec_view
    enforce_this params[:id] && (@plan = @current_org.payment_plans.find_by_id(params[:id]))
    ren_cont 'rec_view', {:plan => @plan} and return
  end

  def rec_new
    (@plan = PaymentPlan.new(:start => Date.today)).organisation = @current_org
    if params[:commit]
      @plan.update_attributes params[:payment_plan]
      if (c = @current_org.contacts.find_by_id params[:contact_id]) && (@plan.contact = c) && @plan.save
        insert_items params[:item_ids], @plan
        ren_cont 'rec_view', {:plan => @plan} and return
      else
        @plan.errors.add "Chosen contact" unless c
        flash[:error] = get_error_msgs @plan
      end
    end
    ren_cont 'rec_new', {:plan => @plan, :contacts => @current_org.customers} and return
  end

  def rec_process
    if params[:id]
      return unless (@plan = @current_org.payment_plans.find_by_id(params[:id])) && @plan.needs_processing?
      ren_cont 'rec_process_return', {:plans => [@plan]} and return
    elsif params[:all] || true
      @plans = @current_org.payment_plans.select(&:needs_processing?)
      ren_cont 'rec_process_return', {:plans => @plans} and return
    end
    return
  end

end










