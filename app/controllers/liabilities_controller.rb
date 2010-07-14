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
    @liabilities = @current_org.liabilities.paginate :page => (params[:page] || '1')
    ren_cont 'index', {:liabilities => @liabilities} and return
  end

  def new
    edit
  end

  def edit
    (@liability = Liability.new).organisation = @current_org unless params[:id] && (@liability = @current_org.liabilities.find_by_id(params[:id]))
    enforce_this @liability.been_paid? == false
		logger.info "Edit method"
		if params[:commit]
      @liability.update_attributes params[:liability]
      if params[:contact_id]
        return unless (c = @current_org.contacts.find_by_id params[:contact_id])
        @liability.contact = c
      end
      if @liability.save
        ren_cont 'view', {:liability => @liability} and return
      else
        flash[:error] = get_error_msgs @liability
      end
    end
    @contacts = @current_org.suppliers
    ren_cont 'edit', {:liability => @liability, :contacts => @contacts} and return
  end

  def view
    enforce_this params[:id] && (@liability = @current_org.liabilities.find_by_id(params[:id]))
		logger.info "View method"
		if params[:commit] && params[:paid_on] && ! @liability.paid_on && params[:paid_on].to_date >= @liability.incurred_on
			make_transaction @liability
      @liability.paid_on = params[:paid_on].to_date
      @liability.save
      flash[:notice] = "Liability marked as paid!"
    end
    ren_cont 'view', {:liability => @liability} and return
  end

	def make_transaction(liability)
	 	t = Transaction.new
		t.type = 'Liability'
		t.liability_id = liability.id
		t.contact_id = liability.contact.id
		t.value = liability.value
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

