class QuotesController < ApplicationController

  private
  def menu_items
    return [
      ['List Quotes', {:url => {:action => :index}}],
      ['New Quote', {:url => {:action => :new}}]
    ]
  end

  public
  def index
    unless @current_project
      @quotes = @current_org.quotes.paginate :page => (params[:page] || '1')
    else
      @quotes = @current_project.quotes.paginate :page => (params[:page] || '1')  
    end
    ren_cont 'index', {:quotes => @quotes} and return
  end

  def new
    edit
  end

  def edit
    (@quote = Quote.new(:produced_on => Date.today, :valid_till => (Date.today + 1.month))).organisation = @current_org unless params[:id] && (@quote = @current_org.quotes.find_by_id(params[:id]))
    if params[:commit]
      @quote.update_attributes params[:quote]
      if params[:contact_id]
        return unless (c = @current_org.contacts.find_by_id params[:contact_id])
        @quote.contact = c
      end
      if @quote.save
        insert_items params[:item_ids], @quote
        ren_cont 'view', {:quote => @quote} and return
      else
        flash[:error] = get_error_msgs @quote
      end
    end
    ren_cont 'edit', {:quote => @quote, :contacts => @current_org.customers} and return
  end

  def convert_to_invoice
    enforce_this params[:id] && (@quote = @current_org.quotes.find_by_id(params[:id]))
    @invoice = Invoice.new
    @invoice.produced_on = @quote.produced_on
    @invoice.due_on = @invoice.produced_on + 1.month
    @invoice.contact = @quote.contact
    @invoice.organisation = @current_org
    @invoice.quote = @quote
    @invoice.project_id = @quote.project_id
    if @invoice.save
      @quote.items.each {|i|
        item = i.clone
        item.quote = nil
        item.invoice = @invoice
        item.save
      }
      flash[:notice] = "Sucessfully converted"
    else
      flash[:error] = "Something went wrong!"
    end
    ren_cont 'invoices/view', {:invoice => @invoice} and return
  end

  def view
    enforce_this params[:id] && (@quote = @current_org.quotes.find_by_id(params[:id]))
    if params[:format] && params[:format] = 'pdf'
      @filename = "#{@current_org.name} quote - #{@quote.produced_on}.pdf"
      send_data render_to_string(:partial => 'view_pdf', :locals => {:quote => @quote}), :type => :pdf, :disposition => 'inline', :filename => @filename and return 
    end
    ren_cont 'view', {:quote => @quote} and return
  end

end
