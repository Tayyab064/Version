class UserController < ApplicationController
	before_filter :restrict_access, except: [:create , :signin]

	def create
		@user = User.create(user_params)
		if @user.id.present?
			@user.generate_email_token
			@user.save
			UserMailer.welcome_email(@user).deliver_later
			render json: @user , status: :created
		else
			render json: @user.errors , status: :unprocessable_entity
		end
	end

	def signin
		if user = User.find_by_email(params[:user][:email])
			if params[:user][:password].present?
				if @user = user.authenticate(params[:user][:password])
					@user.create_tokens
			    	render json: @user , status: :ok
				else
					render json: {'message' => 'Invalid password!'} , status: :unauthorized
				end
			else
				render json: {'message' => 'Params are missing'} , status: :bad_request
			end
		else
			render json: {'message' => 'Kindly signup!'} , status: :unauthorized
		end
	end

	def index
		@user = User.all
		render json: @user , status: :ok
	end

	def update
		@user = @current_user
		if @user.update(user_update_params)
		  render json: @user, status: :accepted
		else
		  render json: @user.errors, status: :unprocessable_entity
		end
	end

	def destroy
		@user = @current_user
		@user.ApiKey.destroy
		head :no_content
	end

	private
	def user_params
		params.require(:user).permit(:first_name , :last_name , :email , :password)
	end

	def user_update_params
		params.require(:user).permit(:first_name , :last_name , :password)
	end
end
