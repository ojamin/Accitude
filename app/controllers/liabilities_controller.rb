class LiabilitiesController < ApplicationController

  private
  def menu_items
    return [
      ['List Liabilities', {:url => {:action => :index}}],
      ['New Liability', {:url => {:action => :new}}]
    ]
  end

  public
  def index
    if @current_project
      @liabilities = @current_project.liabilities.paginate :page => (params[:page] || '1')
    else
      @liabilities = @current_org.liabilities.paginate :page => (params[:page] || '1')
    end
    ren_cont 'index', {:liabilities => @liabilities} and return
  end

  def new
    edit
  end

  def edit
    enforce_this (@liability = Liability.new).organisation = @current_org unless params[:id] && @liability = @current_org.liabilities.find_by_id(params[:id]) 
    enforce_this @current_org.suppliers.count > 0
    logger.info "HHHHHHHHHHHHHHH #{@liability.inspect} HHHHHHHHHHH"
    enforce_this @liability.been_paid? == false
    logger.info "Edit method"
    if params[:commit]
      @liability.update_attributes params[:liability]
      if params[:contact_id]
        return unless (c = @current_org.contacts.find_by_id params[:contact_id])
        @liability.contact = c
      end
      if @liability.save
        ren_cont 'view', {:image => Image.new, :liability => @liability} and return
      else
        flash[:error] = get_error_msgs @liability
      end
    end
    @contacts = @current_org.suppliers
    ren_cont 'edit', {:liability => @liability, :contacts => @contacts} and return
  end

  def view
    enforce_this params[:id] && (@liability = @current_org.liabilities.find_by_id(params[:id]))
    if @liability.image
      @image = @liability.image
    else
      @image = Image.new
    end
    logger.info "View method"
    if params[:commit] && params[:paid_on] && ! @liability.paid_on && params[:paid_on].to_date >= @liability.incurred_on
      make_transaction @liability
      @liability.paid_on = params[:paid_on].to_date
      @liability.save
      flash[:notice] = "Liability marked as paid!"
    end
    ren_cont 'view', {:image => @image, :liability => @liability} and return
  end

  def image_view
    @image = Image.find_by_id params[:id]
  end

  def add_image
    @liability = Liability.find_by_id params[:lid]

    responds_to_parent do
      if params[:image]
        @image = Image.new(params[:image])
        @liability.image.destroy if @liability.image
        @liability.image = @image
      end
      logger.info @image.inspect
      unless @image.save
        flash[:error] = 'Receipt failed to save'
        view 
      else
        logger.info "HHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHhh"
        flash[:notice] = 'Receipt image added'
        view
      end 
    end and return 

    ren_cont 'view', {:liability => @liability} and return
  end

  def delete_image
    @liability = Liability.find_by_id params[:lid]
    @image = Image.find_by_id params[:id]
    if @image.delete
      flash[:notce] = "Image deleted"
    end
    ren_cont 'view', {:liability => @liability} and return
  end

  def make_transaction(liability)
     t = Transaction.new
    t.ttype = 'Liability'
    t.liability_id = liability.id
    t.contact_id = liability.contact.id
    t.value = liability.value
    if liability.project
      t.project_id = liability.project_id
    end
    t.kind = 'Debit'
    t.desc = "Paid to #{liability.contact.name} for #{liability.description}"
    t.organisation_id = @current_org.id
    t.save
    logger.info "Transaction script has been called"  
  end

  def remove
    enforce_this params[:id] && (@liability = @current_org.liabilities.find_by_id(params[:id])) && @liability.been_paid? == false
    @liability[:type] = "RemovedLiability"
    @liability.save
    flash[:notice] = "Liability removed!"
    index
  end

end

