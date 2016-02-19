require 'test_helper'

class UsersLoginTest < ActionDispatch::IntegrationTest
	def setup
		@user = users(:chris)
	end

	test "Log in with invalid information" do
		# first we will get the login path
		get login_path

		# assert that we actually are redirected to the login page
		assert_template 'sessions/new'

		# send a post request i.e. log in
		post login_path, session: { email: "", password: "" }

		# assert template again
		assert_template 'sessions/new'

		# assert that the flash isn't empty, because it shouldn't be
		# (there should be a warning message string in there)
		assert_not flash.empty?

		# send any kind of request to empty the flash
		get root_path

		# flash should be empty now
		assert flash.empty?
	end

	# same test but with valid info
	# so we're testing that the links in the navbar change
	test "Log in with valid information then logout" do
		get login_path
		assert_template 'sessions/new'
		post login_path, session: { email: @user.email, password: 'password' } # standardize 'password' for test users
		assert is_logged_in?
		assert_redirected_to @user
		follow_redirect!
		assert_template 'users/show'
		assert_select 'a[href=?]', login_path, count: 0
		assert_select 'a[href=?]', logout_path
		assert_select 'a[href=?]', user_path(@user)

		# logout
		delete logout_path
		assert_not is_logged_in?
		assert_redirected_to root_url
		follow_redirect!
		assert_select 'a[href=?]', login_path
		assert_select 'a[href=?]', logout_path,      count: 0
		assert_select 'a[href=?]', user_path(@user), count: 0

	end
end
