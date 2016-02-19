class SessionsController < ApplicationController
  def new
  end

  def create
  	# temp variable for user
  	user = User.find_by(email: params[:session][:email])

  	# Find user and then authenticate using provided password
  	if user && user.authenticate(params[:session][:password])
  		# log user in and redirect to 'show' page for the user
  		log_in user

      # TEMP: test to see if Remember me functionality is working
      remember user

  		redirect_to user
  	else
  		# Otherwise, we just render 'new' and show an error message
  		# We use flash.now instead of just flash so that a render
  		# will clear the flash even though we don't send a new request
  		flash.now[:danger] = "Invalid email or password."

  		render 'new'
  	end
  end

  def destroy
    # call the log_out method in sessions_helper.rb
  	log_out

    # redirect to the home page
    redirect_to root_url # user URLS for 'redirect_to'
  end
end
