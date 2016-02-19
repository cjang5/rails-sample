class User < ActiveRecord::Base
  # Create an editable variable 'remember_token' for use in 
  # the remember me digests for the user
  attr_accessor :remember_token
  
	# before_save callback to make sure email is lowercase
	before_save { self.email = self.email.downcase }

	# Make sure user has a name with acceptable length (MAX = 50)
	validates :name,  presence: true, length: { maximum: 50 }	

	# Valid email regex (regular expression) to check email format
	VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\-.]+\.[a-z]+\z/i

	# Make sure user has an email with acceptable length (MAX = 255)
	# Also ensure that there are no duplicate emails (for obvious reasons)
	validates :email, presence: true, length: { maximum: 255 },
									  format: { with: VALID_EMAIL_REGEX },
									  uniqueness: { case_sensitive: false }

  # Make sure user has a secure password
  has_secure_password

  # Make sure user's password has correct length
  validates :password, length: { minimum: 6 }
  validates :password_confirmation, length: { minimum: 6 }

  # a class method to manually create a password digest for
  # the given string 'password'. We will use this mainly
  # in integrations tests with test users where we need to 
  # fill in the attributes for a new user
  def User.digest(password)
  	# The computational cost for generating the password digest
  	cost = ActiveModel::SecurePassword.min_cost ? BCrypt::Engine::MIN_COST : BCrypt::Engine.cost

  	# Create the password digest using BCrypt and 'cost'
  	digest = BCrypt::Password.create(password, cost: cost)
  end

  # Returns a urlsafe base64 string
  def User.new_token
    SecureRandom.urlsafe_base64
  end

  # Create a new remember_me digest for the user for use in a persistent session.
  def remember
    # Give the user a remember_me token string
    self.remember_token = User.new_token

    # Store the digest of the remember_token in the user model
    update_attribute(:remember_digest, User.digest(self.remember_token))
  end

  # Forgets the user, clearing the permanent session
  def forget
    update_attribute(:remember_digest, nil)
    # We don't need the below line because if we update remember_digest to nil, then
    # you cannot use the old remember_token anyway, so it is unnecessary
    # self.remember_token = nil
  end

  # Authenticate the user based on the remember_token
  # will return true if the given token matches our hash
  # If the remember_digest is nil, then we just return false
  # This will solve the VERY subtle bug of having 2 different browsers open and logging out
  # of one but not the other
  def authenticated?(remember_token)
    if remember_digest.nil?
      return false
    end
    BCrypt::Password.new(remember_digest).is_password?(remember_token)
  end
end
