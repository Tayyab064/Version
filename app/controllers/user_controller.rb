class UserController < ApplicationController
	before_filter :restrict_access, except: [:create]

	def create
		@user = User.create(user_params)
		render json: @user , status: :created
	end

	def index
		@user = User.all
		render json: @user , status: :ok
	end

	private
	def user_params
		params.require(:user).permit(:first_name , :last_name , :email , :password)
	end
end
