class ProjectsController < ApplicationController

	private
	def menu_items
		return [
			['New project', {:url => {:action => :create, :id => @org.id}}]
		]
	end

	public
	def index
		enforce_this(@org = Organisation.find_by_id(params[:id]))	
		ren_cont 'index', {:org => @org} and return
	end

	def create
		enforce_this(@org = Organisation.find_by_id(params[:id]))
		@project = Project.new
		if params[:commit]
			if @project.update_attributes params[:project]
				@project.update_attribute :organisation_id, @current_org.id
				flash[:notice] = "Project created"
				ren_cont 'index', {:id => @org.id} and return
			else
				flash[:notice] = "Project must have a unique name."
			end
		end
		ren_cont 'create', {:project => @project, :id => @org.id} and return
	end

	def edit
		enforce_this(@project = Project.find_by_id(params[:pid]))
		@org = Organisation.find_by_id params[:id]
		logger.info @project	
		if params[:commit]
			if @project.update_attributes params[:project]
				flash[:notice] = "Project updated"
				ren_cont 'index', {:id => @org.id} and return
			else
				flash[:notice] = "Project must have a unique name"
			end
		end
		ren_cont 'edit', {:project => @project, :id => @org.id, :pid => params[:pid]}
	end

	def delete
		#enforce_this(params[:id] && params[:pid] && @org = Organisation.find_by_id(params[:id]) && @project = Project.find_by_id(params[:pid]))
		enforce_this(@project = Project.find_by_id(params[:pid]))
		@org = Organisation.find_by_id params[:id]
		logger.info @org
		logger.info @project
		@project.delete
		flash[:notice] = "Project '#{@project.name}' deleted"	
		ren_cont 'index', {:id => @org.id} and return
	end

	def set_project
		set_active_project_id params[:id] if params[:id]
		logger.info "HHHHHHH #{@current_project}"
		redirect_to :controller => :main, :action => :index and return
	end

#	def set_active_project_id(proj)
#		proj = proj.to_i
#		@project = Project.find_by_id proj
#		@org = @project.organisation
#		session[:project_id] = proj and setup_project and return true if @logged_in && (@logged_in.is_admin || @logged_in.organisation.ids.include?(@org.id))
#		return false
#	end

#	def setup_project
#		return false unless @logged_in
#		
#	end

end
