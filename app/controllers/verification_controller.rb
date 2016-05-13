class VerificationController < ApplicationController

	def verify_email
		if user = User.find_by_email_token(params[:token])
			user.update(email_verified: true , email_token: nil)
			render json: {'message' => 'Email Successfully verified!'} , status: :ok
		else
			render json: {'message' => 'Invalid token!'} , status: :unprocessable_entity
		end
	end

	def resend_email_token
		if params[:email].present?
			if user = User.find_by_email(params[:email])
				if user.email_verified == false
					user.generate_email_token
					user.save
					UserMailer.welcome_email(user).deliver_later
					render json: {'message' => 'Kindly go to your email!'} , status: :ok
				else
					render json: {'message' => 'Email Already Verified!'} , status: :bad_request
				end
			else
				render json: {'message' => 'Signup first!'} , status: :unprocessable_entity
			end
		else
			render json: {'message' => 'Params are missing'} , status: :unprocessable_entity
		end
	end
end
