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
    if @role.save
      redirect_to @role, notice: 'role was successfully created.'
    else
      render :new
    end
  end

  def update
    if @role.update_attributes(params[:role])
      redirect_to @role, notice: 'role was successfully updated.'
    else
      render :edit
    end
  end

  def destroy
    @role.destroy

    redirect_to roles_url
  end
end
