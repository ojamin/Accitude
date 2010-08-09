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

end
