class SessionsController < ApplicationController
  def index
  end

  def show
    @active_user = User.find_by(id:session[:active])
    @in_state = Event.joins(:user).where(state:@active_user.state)
    @out_state = Event.where.not(state:@active_user.state)
    @attending = User.find(session[:active]).events_attending
    @today = Date.today
  end

  def new
  end

  def edit
    @edit_event = Event.find_by(id:params[:id])
    render "edit"
  end

  def create
    # Log in
    @user = User.find_by(email: params[:login][:email].downcase)
    respond_to do |format|
      if @user && @user.authenticate(params[:login][:password])
        session[:active] = @user.id
        format.html { redirect_to "/sessions/#{@user.id}"}
        format.json { render :show, status: :created, location: "/sessions/#{@user.id}"}
      else
        format.html { redirect_to '/',   notice: 'Your email and/or password were incorrect. Get your life together and try again'}
        format.json { render json: @user.errors, status: :unprocessable_entity }
      end
    end
  end

  def update
    # render json:params[:event][:date]
    Event.find_by(id:params[:id]).update(name:params[:event][:name], date:params[:event][:date],city:params[:event][:city],state:params[:event][:state])
    redirect_to "/sessions/#{session[:active]}"
  end

  def destroy
    session[:active] = nil
    redirect_to '/'
  end
end
