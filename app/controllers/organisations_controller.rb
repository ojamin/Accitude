class OrganisationsController < ApplicationController

  skip_before_filter :enforce_org
  
  private
  def menu_items
    return [['List Organisations', {:url => {:action => :index}}]]
  end
  
  public
  def index
    if @logged_in.is_admin
      @orgs = Organisation.find :all
      @orgs = @orgs.paginate :page => (params[:page] || '1')
    else
      @orgs = @logged_in.organisations.paginate :page => (params[:page] || '1')
    end
    ren_cont 'index', {:orgs => @orgs}
  end

  def set_org
    set_active_org_id params[:id] if params[:id]
    redirect_to :controller => :main, :action => :index and return
  end

  def edit
    enforce_this params[:id] && (@org = (@logged_in.is_admin ? Organisation.find_by_id(params[:id]) : @logged_in.organisations.find_by_id(params[:id])))
    if params[:commit]
      responds_to_parent do
        @org.update_attributes params[:organisation]
        @org.save
        if params[:image]
          @img = Image.new(params[:image])
          @org.image.destroy if @org.image
          @org.image = @img
          @img.save
        end
        ren_cont 'edit_fin'
      end and return
    end
    ren_cont 'edit', {:org => @org} and return
  end

end
