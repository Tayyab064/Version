class UserMailer < ApplicationMailer
	def welcome_email(user)
		@user = user
    	@url  = 'https://wifi-api.herokuapp.com'
    	mail(to: @user.email, subject: 'WifiExplore', body: 'Welcome '+ @user.first_name )
	end
end
