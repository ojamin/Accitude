class MainController < ApplicationController

  before_filter :enforce_login, :except => [:index, :login]
  skip_before_filter :enforce_org

  def index
  end

  def login
    if params[:commit] && params[:username] && params[:password] && (@user = User.user_login(params[:username], params[:password]))
      session[:uid] = @user.username
      flash[:notice] = 'Your now logged in!'
      redirect_to :action => :index and return
    elsif params[:commit]
      flash[:error] = 'Login failed'
    end
  end

  def logout
    session[:uid] = nil
    flash[:notice] = 'Logged out!'
    session[:org_id] = nil
    redirect_to :action => :index and return
  end

end
