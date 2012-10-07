class DutiesController < ApplicationController
  before_filter :authenticate_user!
  authorize_actions_for Duty, actions: { take: :update }

  def index
    @duties = Duty.includes(:users).all
  end

  def show
    @duty = Duty.find(params[:id])
    @users = User.on_rota
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

  def take
    Duty.where(id: params[:ids]).each do |duty|
      user = duty.users.joins(:preferences).where(preferences: { duty_id: duty.id }).first
      current_preference = duty.preferences.where(user_id: current_user.id)
      if current_preference.present?
        current_preference.destroy
      end
      duty.users.delete(user)
      duty.users << current_user
    end

    redirect_to :back, notice: "These duties have been assigned to you"
  end
end
