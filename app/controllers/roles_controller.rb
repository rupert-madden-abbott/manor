class RolesController < ApplicationController
  before_filter :authenticate_user!
  authorize_actions_for Role

  def index
    @roles = Role.all
  end

  def show
    @role = Role.find(params[:id])
  end

  def new
    @role = Role.new
  end

  def edit
    @role = Role.find(params[:id])
  end

  def create
    @role = Role.new(params[:role])

    if @role.save
      redirect_to @role, notice: 'role was successfully created.'
    else
      render :new
    end
  end

  def update
    @role = Role.find(params[:id])
    if @role.update_attributes(params[:role])
      redirect_to @role, notice: 'role was successfully updated.'
    else
      render :edit
    end
  end

  def destroy
    @role = Role.find(params[:id])
    @role.destroy

    redirect_to roles_url
  end
end
