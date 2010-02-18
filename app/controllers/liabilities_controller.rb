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
    ren_cont 'view', {:liability => @liability} and return
  end

end

