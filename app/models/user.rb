class User < ActiveRecord::Base
	has_one :ApiKey
	has_secure_password

	after_create :create_tokens
	validates_uniqueness_of :email


	def create_tokens
	  	ApiKey.create :user => self
	end
end
