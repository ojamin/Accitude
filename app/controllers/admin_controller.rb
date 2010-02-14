class AdminController < ApplicationController
  
  before_filter :enforce_admin
  skip_before_filter :enforce_org

  private
  def menu_items
    return [
      ["List Users", {:url => {:action => :users}}],
      ["Add User", {:url => {:action => :user_new}}],
      ["List Orgs", {:url => {:action => :orgs}}],
      ["Add Org", {:url => {:action => :org_new}}]
    ]
  end

  public
  def index
    ren_cont 'index', {} and return
  end

  def users
    @users = User.find :all
    ren_cont 'users', {:users => @users} and return
  end

  def user_new
    user_edit
  end

  def user_edit
    @user = User.new unless params[:id] && (@user = User.find_by_id(params[:id]))
    if params[:commit] && params[:user][:username] && params[:user][:email]
      pass_fine = true
      if params[:password] && params[:password].size > 0
       if params[:passagain] && params[:password] == params[:passagain]
          @user.password = params[:password]
        else
          pass_fine = false
          @user.errors.add "The password"
        end
      end
      @user.username = params[:user][:username]
      @user.email = params[:user][:email]
      if pass_fine && @user.save
        flash[:notice] = (params[:action] == "user_new" ? "User created!" : "User updated!")
        ren_cont 'user_view', {:user => @user} and return
      end
      flash[:notice] = get_error_msgs @user
    end
    ren_cont 'user_edit', {:user => @user} and return
  end

  def user_view
    enforce_this params[:id] && (@user = User.find_by_id(params[:id]))
    ren_cont 'user_view', {:user => @user} and return
  end

  def orgs
    @orgs = Organisation.find :all
    ren_cont 'orgs', {:orgs => @orgs} and return
  end

  def org_new
    enforce_this params[:commit] && params[:name]
    @org = Organisation.new(:name => params[:name])
    if false && @org.save
      flash[:notice] = "Organisationi created!"
      flash[:error] = "foo"
      render :update do |page|
        gen_flash page
        page.insert_html :bottom, :orgs_list, link_to_remote(@org.name, :url => {:action => :org_view, :controller => :admin, :id => @org.id})
      end and return
    end
    flash[:error] = get_error_msgs(@org)
    render :update do |page|
      gen_flash page
    end and return
  end

  def org_mod_user
    enforce_this params[:id] && (@org = Organisation.find_by_id(params[:id])) &&
      params[:uid] && (@user = User.find_by_id(params[:uid]))  &&
      params[:access] && ["0", "1"].include?(params[:access])
    if params[:access] == "1"
      @org.users << @user unless @org.users.include? @user
      flash[:notice] = "User added"
      logger.info "flash: #{flash[:notice]}"
      render :update do |page|
        gen_flash page
        page["org_mod_user_new"].remove
        sel_opts = options_from_collection_for_select((User.find(:all) - @org.users), 'id', 'username')
        page.insert_html :bottom, :org_mod_user, gen_list([[@user.username, link_to_remote('Remove access', :url => {:action => :org_mod_user, :controller => :admin, :id => @org.id, :uid => @user.id, :access => 0}), {:id => "org_mod_user_#{@user.id}"}], [select_tag(:uid, sel_opts), submit_tag('Add access'), {:id => "org_mod_user_new"}]], :size => 2, :sublist => true)
      end and return
    end
    @org.users.delete @user
    flash[:notice] = "User removed"
    render :update do |page|
      gen_flash page
      page["org_mod_user_new"].remove
      page["org_mod_user_#{@user.id}"].remove
      sel_opts = options_from_collection_for_select((User.find(:all) - @org.users), 'id', 'username')
      page.insert_html :bottom, :org_mod_user, gen_list([[select_tag(:uid, sel_opts), submit_tag('Add access'), {:id => "org_mod_user_new"}]], :size => 2, :sublist => true)
    end and return
  end

  def org_view
    enforce_this params[:id] && (@org = Organisation.find_by_id(params[:id]))
    ren_cont 'org_view', {:org => @org} and return
  end

end
