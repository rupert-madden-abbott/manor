class PreferencesController < ApplicationController
  before_filter :authenticate_user!
  load_and_authorize_resource
  skip_load_resource only: [:add, :remove]

  def create
    if @preference.save
      redirect_to :back, notice: 'Preference added.'
    else
      render :new
    end
  end

  def destroy
    @preference.destroy

    redirect_to :back, notice: 'Preference removed.'
  end

  def add
    params[:ids].each do |id|
      Preference.create(duty_id: id, user: current_user)
    end

    redirect_to :back, notice: 'Preferences added.'
  end

  def remove
    @preferences = Preference.where(duty_id: params[:ids], user_id: current_user.id)
    @preferences.destroy_all

    redirect_to :back, notice: 'Preferences removed.'
  end
end
