class VerificationController < ApplicationController

	def verify_email
		if user = User.find_by_email_token(params[:token])
			user.update(email_verified: true , email_token: nil)
			render json: {'message' => 'Email Successfully verified!'} , status: :ok
		else
			render json: {'message' => 'Invalid token!'} , status: :bad_request
		end
	end
end
