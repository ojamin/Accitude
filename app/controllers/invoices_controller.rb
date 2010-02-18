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
    @invoices = @current_org.invoices.paginate :page => (params[:page] || '1')
    ren_cont 'index', {:invoices => @invoices} and return
  end

  def new
    edit
  end

  def edit
    (@invoice = Invoice.new).organisation = @current_org unless (params[:id] && (@invoice = Invoice.find_by_id(params[:id])))
    if params[:commit]
      @invoice.update_attributes params[:invoice]
      if params[:contact_id]
        return unless (c = @current_org.contacts.find_by_id params[:contact_id])
        @invoice.contact = c
      end
      if @invoice.save
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
      send_data render_to_string(:partial => 'view_pdf', :locals => {:invoice => @invoice}), :type => :pdf, :disposition => 'inline', :filename => 'test.pdf' and return
    end
    ren_cont 'view', {:invoice => @invoice} and return
  end

  def rec_end
    enforce_this params[:id] && (@plan = @current_org.payment_plans.find_by_id(params[:id]))
    @plan.times = 0
    @plan.save
    ren_cont 'rec_view', {:plan => @plan} and return
  end

  def rec_index
    @plans = @current_org.payment_plans.paginate :page => (params[:page] || '1')
    ren_cont 'rec_index', {:plans => @plans} and return
  end

  def rec_view
    enforce_this params[:id] && (@plan = @current_org.payment_plans.find_by_id(params[:id]))
    ren_cont 'rec_view', {:plan => @plan} and return
  end

  def rec_new
    (@plan = PaymentPlan.new).organisation = @current_org
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
      return unless (@plan = @current_org.payment_plans.find_by_id(params[:id])) &&
                    @plan.needs_processing?
      ren_cont 'rec_process_return', {:plans => [@plan]} and return
    elsif params[:all] || true
      @plans = @current_org.payment_plans.select(&:needs_processing?)
      ren_cont 'rec_process_return', {:plans => @plans} and return
    end
    return
  end

end















