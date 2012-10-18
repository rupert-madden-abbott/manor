class DutiesController < ApplicationController
  before_filter :authenticate_user!
  load_and_authorize_resource
  skip_load_resource only: :take

  def show
    @users = User.on_rota
  end

  def new
    @duties = Duty.all
  end

  def edit
  end

  def create
    if @duty.save
      redirect_to @duty, notice: 'Duty was successfully created.'
    else
      render :new
    end
  end

  def update
    if @duty.update_attributes(params[:duty])
      redirect_to @duty, notice: 'Duty was successfully updated.'
    else
      render :edit
    end
  end

  def destroy
    @duty.destroy
    redirect_to rotum_url(:current)
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
