class UsersController < ApplicationController
  def index
  end

  def show
  end

  def new
  end

  def edit
  end

  def create
      @user = User.new(user_params)
      respond_to do |format|
        if @user.save
          session[:active] = @user.id
          format.html { redirect_to "/sessions/#{@user.id}", notice: 'User was successfully created.' }
          format.json { render :show, status: :created, location: "/sessions/#{@user.id}"}
        else
          format.html { redirect_to '/', notice: @user.errors.full_messages}
          format.json { render json: @user.errors, status: :unprocessable_entity }
        end
      end
  end

  def update
  end

  def destroy
  end

  private
  def user_params
    params.require(:user).permit(:first_name, :last_name, :email, :city, :state, :password, :password_confirmation)
  end
end
