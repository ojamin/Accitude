class MainController < ApplicationController

  before_filter :enforce_login, :except => [:index, :login]
  skip_before_filter :enforce_org

  def index
    render :action => :index and return
  end

  def login
    if params[:commit] && params[:username] && params[:password] && (@user = User.user_login(params[:username], params[:password]))
      session[:uid] = @user.username
      flash[:notice] = 'Your now logged in!'
      check_login
      render :action => :index and return
    elsif params[:commit]
      flash[:error] = 'Login failed'
    end
    render :action => :login and return
  end

  def logout
    session[:uid] = nil
    flash[:notice] = 'Logged out!'
    session[:org_id] = nil
    @logged_in = nil
    check_login
    render :action => :index and return
  end

end
