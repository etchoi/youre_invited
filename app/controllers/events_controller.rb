class EventsController < ApplicationController
  def index
  end

  def show
    # 
    Attendee.where(user_id:session[:active], event_id:params[:id]).delete_all
    redirect_to "/sessions/#{session[:active]}"
  end

  def new
    @add_comment = Comment.new(content:params[:event][:comment], user_id:session[:active], event_id:params[:id])

    respond_to do |format|
      if @add_comment.save
        format.html { redirect_to "/events/#{params[:id]}/edit" }
        format.json { render :show, status: :created, location: "/events/#{params[:id]}/edit"}
      else
        format.html { redirect_to "/events/<%= x.id %>/edit", notice: 'Your event was not successfully created. Try again (Sad face)'}
        format.json { render json: @user.errors, status: :unprocessable_entity }
      end
    end
    # render json:params[:event][:comment]
  end

  def edit
    @event_info = Event.joins(:user).find(params[:id])
    # Find users attending this event
    @event_attendee = Attendee.joins(:user).where(event_id:params[:id])
    # Find the total 'count' of people attending this event instance
    @event_count = Attendee.where(event_id:params[:id]).count
    # Find comments for this event instance
    @event_comments = Comment.joins(:user).where(event_id:params[:id])
  end

  def create
    @event = User.find(session[:active]).events.new(event_params)
    respond_to do |format|
      if @event.save
        format.html { redirect_to "/sessions/#{session[:active]}", notice: 'Event was successfully created. Party on!' }
        format.json { render :show, status: :created, location: "/sessions/#{@user.id}"}
      else
        format.html { redirect_to "/sessions/#{session[:active]}", notice: @event.errors.full_messages}
        format.json { render json: @user.errors, status: :unprocessable_entity }
      end
    end
  end

  def update
    @attend = Attendee.create(user_id:session[:active], event_id:params[:id])

    respond_to do |format|
      if @attend.save
        format.html { redirect_to "/sessions/#{params[:id]}", notice: "You have joined the event. Party on!" }
        format.json { render :show, status: :created, location: "/sessions/#{params[:id]}"}
      else
        format.html { redirect_to "/sessions/#{session[:active]}", notice: "There was a problem. Try again (Sad face)"}
        format.json { render json: @user.errors, status: :unprocessable_entity }
      end
    end

  end

  def destroy
    Event.where(id:params[:id]).destroy_all
    redirect_to "/sessions/#{params[:id]}"
  end

  private
  def event_params
    params.require(:event).permit(:name, :date, :city, :state)
  end
end
