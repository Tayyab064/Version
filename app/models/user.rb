class User < ActiveRecord::Base
	has_one :ApiKey
	has_secure_password

	after_create :create_tokens
	validates_uniqueness_of :email

	scope :approved , lambda {where(email_verified: true)}


	def create_tokens
	  	ApiKey.create :user => self
	end

	def generate_email_token
		begin
		  self.email_token = SecureRandom.hex.to_s
		end while self.class.exists?(email_token: email_token)
	end
end
