class EventsController < ApplicationController
  before_filter :authenticate_user!
  load_and_authorize_resource

  def index
  end

  def show
  end

  def new
  end

  def edit
  end

  def create
    if @event.save
      redirect_to @event, notice: 'event was successfully created.'
    else
      render :new
    end
  end

  def update
    if @event.update_attributes(params[:event])
      redirect_to @event, notice: 'event was successfully updated.'
    else
      render :edit
    end
  end

  def destroy
    @event.destroy

    redirect_to events_url
  end
end
