module SessionsHelper
	# Log in the user
	def log_in(user)
		# user 'session' to log in the given user
		session[:user_id] = user.id
	end

	# return the current logged in user
	def current_user
		# long way
		# if @current_user.nil?
			# @current_user = User.find_by(id: session[:user_id])
		# else
			# @current_user
		# end

		# cool way
		#@current_user ||= User.find_by(id: session[:user_id])

		# we need to support remember me tokens and permanent sessions
		if session[:user_id]
			@current_user ||= User.find_by(id: session[:user_id])
		elsif cookies.signed[:user_id]
			# temporary variable holding user
			user = User.find_by(id: cookies.signed[:user_id])

			# check if 'user' exists, and if so, authenticate its remember_token
			# we will use a helper function authenticated? for validation
			if user && user.authenticated?(cookies[:remember_token])
				# so if the user is valid and is authenticated, we will set 
				# @current_user to 'user' and log the user in
				log_in user
				@current_user = user
			end
		end
	end

	# returns if there is a user logged in, false otherwise
	# *** THIS CALLS 'current_user', NOT @current_user !!! ***
	def logged_in?
		!current_user.nil?
	end

	# logs the user out
	def log_out
		session.delete(:user_id)
		# The following line is equivalent to above
		# session[:user_id] = nil

		# make sure we don't leave a @current_user lying around
		@current_user = nil
	end

	# Call the User class method 'remember' and set the cookies to create
	# a persistent session
	def remember(user)
		# call
		user.remember

		# set cookies to expire 20 years from now (standard convention)
		# the '.signed' ensures that 'user.id' is encrypted like session[:user_id] 
		# automatically does
		cookies.permanent.signed[:user_id] = user.id
		# the below code is the long version of the cookies.permanent method
		# cookies[:user_id] = { value:   user.id,
		# 					  expires: 20.years.from_now.utc }

		# we will also store the user's remember_token 
		# this is the equivalent of storing the raw password of the user for 'session'
		cookies.permanent[:remember_token] = user.remember_token
	end
end
