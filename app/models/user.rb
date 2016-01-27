class User < ActiveRecord::Base
	# Make sure user has a name with acceptable length (MAX = 50)
	validates :name,  presence: true, length: { maximum: 50 }	

	# Valid email regex (regular expression) to check email format
	VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\-.]+\.[a-z]+\z/i

	# Make sure user has an email with acceptable length (MAX = 255)
	# Also ensure that there are no duplicate emails (for obvious reasons)
	validates :email, presence: true, length: { maximum: 255 },
									  format: { with: VALID_EMAIL_REGEX },
									  uniqueness: { case_sensitive: false }
end
