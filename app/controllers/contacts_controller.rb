class ContactsController < ApplicationController

  private
  def menu_items
    return [
      ['List Contacts', {:url => {:action => :index}}],
      ['Add Contact', {:url => {:action => :new}}]
    ]
  end
  
  public
  def index
    @contact_list = @current_org.contacts.paginate :page => (params[:page] || '1')
    ren_cont 'index', {:contact_list => @contact_list} and return
  end

  def view
    enforce_this (params[:id] && (@contact = @current_org.contacts.find_by_id(params[:id].to_s)))
    ren_cont 'view', {:contact => @contact} and return
  end

  def new
    edit
  end

  def edit
    (@contact = Contact.new).organisation = @current_org unless params[:id] && (@contact = @current_org.contacts.find_by_id(params[:id]))
    if params[:commit]
      @contact.update_attributes params[:contact]
      if @contact.save
        flash[:notice] = (params[:action] == 'new' ? 'Contact created!' : 'Contact updated!')
        ren_cont 'view', {:contact => @contact} and return
      else
        flash[:error] = get_error_msgs @contact
      end
    end
    ren_cont 'edit', {:contact => @contact}
  end

end
