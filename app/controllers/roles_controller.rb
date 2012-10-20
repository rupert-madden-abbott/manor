class RolesController < ApplicationController
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
    @role.save
    respond_with(@role)
  end

  def update
    @role.update_attributes(params[:role])
    respond_with(@role)
  end

  def destroy
    @role.destroy
    respond_with(@role)
  end
end
