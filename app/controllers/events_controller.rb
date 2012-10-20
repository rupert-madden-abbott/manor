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
    @event.save
    respond_with @event
  end

  def update
    @event.update_attributes(params[:event])
    respond_with @event
  end

  def destroy
    @event.destroy
    respond_with @event
  end
end
