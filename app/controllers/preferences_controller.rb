class PreferencesController < ApplicationController
  before_filter :authenticate_user!
  before_filter :assign_defaults, only: :create
  load_and_authorize_resource

  def create
    @preference.save
    respond_with(@preference)
  end

  def destroy
    @preference.destroy
    respond_with(@destroy)
  end

  private

  def assign_defaults
    params[:preference][:user_id] ||= current_user.id
  end
end
