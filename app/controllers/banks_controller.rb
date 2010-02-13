class BanksController < ApplicationController

  private
  def menu_items
    return [
      ['List Bank Accounts', {:url => {:action => :index}}],
      ['New Bank Account', {:url => {:action => :new}}]
    ]
  end

  public
  def index
    @accounts = @current_org.bank_accounts.paginate :page => (params[:page] || '1')
    ren_cont 'index', {:accounts => @accounts} and return
  end

  def new
    edit
  end

  def edit
    (@account = BankAccount.new).organisation = @current_org unless params[:id] && (@account = BankAccount.find_by_id(params[:id]))
    if params[:commit]
      @account.update_attributes params[:bank_account]
      if @account.save
        ren_cont 'view', {:account => @account} and return
      else
        flash[:error] = get_error_msgs @account
      end
    end
    ren_cont 'edit', {:account => @account} and return
  end

  def view
    enforce_this params[:id] && (@account = @current_org.bank_accounts.find_by_id(params[:id]))
    ren_cont 'view', {:account => @account} and return
  end

end















