class PreferencesController < ApplicationController
  before_filter :authenticate_user!
  authorize_actions_for Preference

  def index
    @preferences = Preference.all
  end

  def show
    @preference = Preference.find(params[:id])
  end

  def new
    @preference = Preference.new
  end

  def edit
    @preference = Preference.find(params[:id])
  end

  def create
    @preference = Preference.new(params[:preference])

    if @preference.save
      redirect_to :back, notice: 'Preference added.'
    else
      render :new
    end
  end

  def update
    @preference = Preference.find(params[:id])
    if @preference.update_attributes(params[:preference])
      redirect_to @preference, notice: 'Preference was successfully updated.'
    else
      render :edit
    end
  end

  def destroy
    @preference = Preference.find(params[:id])
    @preference.destroy

    redirect_to :back, notice: 'Preference removed.'
  end
end
