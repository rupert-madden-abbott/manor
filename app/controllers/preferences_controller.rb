class PreferencesController < ApplicationController
  before_filter :authenticate_user!
  load_and_authorize_resource
  skip_load_resource only: [:add, :remove]

  def create
    @preference.save
    respond_with(@preference, :back)
  end

  def destroy
    @preference.destroy
    respond_with(@destroy, :back)
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
