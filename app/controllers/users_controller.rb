class UsersController < ApplicationController
  
	def show 
		@user = User.find(params[:id])
	end

	def new
		# create a new user (blank)
		@user = User.new
	end

	def create
		@user = User.new(user_params)

		if @user.save 
			# Handle success
			flash[:success] = "Welcome to the Sample App!"
			redirect_to user_url(@user)
		else
			render 'new'
		end
	end

	# Private methods
	private 

		# define user parameters
		def user_params
			params.require(:user).permit(:name, :email, :password, :password_confirmation)
		end
end
