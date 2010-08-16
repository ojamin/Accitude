# Filters added to this controller apply to all controllers in the application.
# Likewise, all the methods added will be available for all controllers.

class ApplicationController < ActionController::Base
  private
  include CacheableFlash
  helper :all # include all helpers, all the time

	require 'redbox'

  # See ActionController::RequestForgeryProtection for details
  # Uncomment the :secret if you're not using the cookie session store
  # protect_from_forgery :secret => '1f29646080aa4f2962b29498878249a3'
  
  # See ActionController::Base for details 
  # Uncomment this to filter the contents of submitted sensitive data parameters
  # from your application log (in this case, all fields with names like "password"). 
  filter_parameter_logging :password, :passagain, :oldpass, :pass

  before_filter :check_login, :enforce_login, :setup_org, :enforce_org, :setup_project

  @logged_in = false
  @current_org = false

  private
  def menu_items
    return []
  end

  def ren_cont(name, locals={}, block=Proc.new {|p| ""})
    @menu = menu_items
    render :update do |page|
      page.gen_dymenu @menu
      block.call(page)
      page.gen_main(render(:partial => name, :locals => locals))
    end	
	end

  def set_active_org_id(org)
    org = org.to_i
    session[:org_id] = org and setup_org and return true if @logged_in && (@logged_in.is_admin || @logged_in.organisation_ids.include?(org))
    return false
  end

  def setup_org
    return false unless @logged_in
    @current_org = (@logged_in.is_admin ? Organisation.find_by_id(session[:org_id]) : @logged_in.organisations.find_by_id(session[:org_id])) if session[:org_id]
  end
  
  def enforce_this(item)
    redirect_to :controller => :main, :action => :login and return unless item
  end

  def enforce_org
    enforce_this @current_org
  end

  def check_login
    return false unless session[:uid]
    return @logged_in if @logged_in
    @logged_in = User.find_by_username(session[:uid])
    session.reset unless @logged_in
    return @logged_in
  end

	def set_active_project_id(proj)
	 	proj = proj.to_i	
		unless proj == 0
			@project = Project.find_by_id proj
			@org = @project.organisation
			logger.info "set Project id called"
			session[:project_id] = proj and setup_project and return true if @logged_in && (@logged_in.is_admin || @logged_in.organisation_ids.include?(@org.id))
			return false
		else
			session[:project_id] = nil
			@current_project = nil
		end
	end

	def setup_project
	 	return false unless @logged_in

 	 	@current_project = Project.find_by_id(session[:project_id])	 
	end

	def enforce_project
		
	end

  def enforce_login
    enforce_this @logged_in
  end

  def enforce_admin
    enforce_this @logged_in.is_admin
  end

  def insert_items(iids, owner)
    item_ids = JSON.parse(iids)
    item_ids.each {|i|
      if (item = Item.find_by_id(i.to_i)) && ! item.has_relationship?
        item.write_attribute "#{owner.class.to_s.underscore}_id", owner.id
        item.save
      end
    }
  end

  def get_error_msgs(obj)
    return obj.errors.full_messages.join(' and ') if obj.errors.size > 0
    return "Error in input"
  end

  def set_no_project
    set_active_project_id 0
		return
	end


end
