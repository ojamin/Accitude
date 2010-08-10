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
				@project.update_attribute :organisation_id, @org.id
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
		flash[:notice] = "Project set to '#{@current_project.name}'"
		logger.info "HHHHHHH #{@current_project}"
		redirect_to :controller => :main, :action => :index and return
	end

	def set_no_project
		set_active_project_id 0
		flash[:notice] = "No current project. All entries currently available"
		redirect_to :controller => :main, :action => :index and return
	end

end
