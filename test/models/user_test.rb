require 'test_helper'

class UserTest < ActiveSupport::TestCase
  def setup
  	@user = User.new(name: "Example User", email: "example@example.com",
                     password: "poopface", password_confirmation: "poopface")
  end

  # Test user validity
  test "should be valid" do 
  	assert @user.valid?
  end

  # test username presence
  test "name should be present" do
  	# TEMP
  	@user.name = "" # empty
  	assert_not @user.valid?
  end

  # test email presence
  test "email should be present" do 
  	# TEMP
  	@user.email = "" # empty
  	assert_not @user.valid?
  end

  # test username length
  test "name should not be too long" do
  	@user.name = "a" * 51 # should pass because it is incorrect
  	assert_not @user.valid?
  end

  # test email length
  test "email should not be too long" do
  	@user.email = "a" * 244 + "@example.com" # should pass
  	assert_not @user.valid?
  end

  # test email validity (format)
  test "email format should be valid" do
    # some valid examples of email addresses
    valid_addresses = %w[user@example.com USER@foo.COM A_US-ER@foo.bar.org
                         first.lang@foo.jp alice+bob@baz.cn]

    # loop thru valid_addresses checking validity of each one, should be green
    valid_addresses.each do |address|
      @user.email = address
      assert @user.valid?, "#{address.inspect} should be valid."
    end 
  end

  # test incorrect email format
  test "email format should be valid (check incorrect format)" do
    # some invalid examples of email addresses
    invalid_addresses = %w[user@example,com user_at_foo.org username@example. 
                           foo@bar_baz.org foo@bar+baz.com]

    # loop tru, checking that each is invalid
    invalid_addresses.each do |address|
      @user.email = address
      assert_not @user.valid?, "#{address} should be invalid."
    end
  end

  # test for duplicate email addresses
  test "email should not already exist" do
    dup = @user.dup
    dup.email = @user.email.upcase
    @user.save # save the user to the database
    assert_not dup.valid? # should be invalid because @user already exists in the database
  end

  # password should have a minimum length of 6
  test "password should have min length of 6" do
    @user.password = "yummybutt"
    @user.password_confirmation = "yummybutt"
    assert @user.valid?
  end
end







