class DutiesController < ApplicationController
  before_filter :authenticate_user!
  authorize_actions_for Duty

  def index
    @duties = Duty.includes(:users).all
  end

  def show
    @duty = Duty.find(params[:id])
  end

  def new
    @duty = Duty.new
    @duties = Duty.all
  end

  def edit
    @duty = Duty.find(params[:id])
  end

  def create
    @duty = Duty.new(params[:duty])

    if @duty.save
      redirect_to @duty, notice: 'Duty was successfully created.'
    else
      render :new
    end
  end

  def update
    @duty = Duty.find(params[:id])
    if @duty.update_attributes(params[:duty])
      redirect_to @duty, notice: 'Duty was successfully updated.'
    else
      render :edit
    end
  end

  def destroy
    @duty = Duty.find(params[:id])
    @duty.destroy
    redirect_to duties_url
  end
end
