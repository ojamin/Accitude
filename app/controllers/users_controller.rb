class UsersController < ApplicationController
  skip_before_filter :enforce_org

  def profile
    ren_cont 'profile', {:user => @logged_in} and return
  end

  def edit_profile
    if params[:commit] && params[:user]
      @logged_in.update_attributes(params[:user])
      pass_fine = true
      if params[:password] && params[:password].size > 0
        if params[:passagain] && params[:password] == params[:passagain]
          @logged_in.password = params[:password]
        else
          pass_fine = false
          @logged_in.errors.add "The password"
        end
      end
      if pass_fine && @logged_in.save
        flash[:notice] = 'Profile updated!'
        ren_cont 'profile', {:user => @logged_in} and return
      end
      flash[:error] = get_error_msgs @logged_in
    end
    ren_cont 'edit_profile', {:user => @logged_in} and return
  end

end
