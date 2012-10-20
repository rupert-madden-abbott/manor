class RotaController < ApplicationController
  before_filter :authenticate_user!
  load_and_authorize_resource
  skip_load_resource only: [:assign, :unassign]

  def index
  end

  def new
  end

  def edit
  end

  def create
    @rotum.create_with_duties
    respond_with(@rotum)
  end

  def update
    @rotum.update_attributes(params[:rotum])
    respond_with(@rotum)
  end

  def destroy
    @rotum.destroy
    respond_with(@destroy)
  end

  def assign
    @rotum = Rotum.includes(:duties).find(params[:id])
    @rotum.assign_duties
    @rotum.save

    redirect_to @rotum, notice: "Duties assigned"
  end

  def unassign
    @rotum = Rotum.includes(:duties).find(params[:id])
    @rotum.duties.each { |duty| duty.users.clear }
    @rotum.assigned = false
    @rotum.save

    redirect_to @rotum, notice: "Duties unassigned"
  end

  def publish
    @rotum.published = true
    @rotum.save

    redirect_to @rotum, notice: "Rota published"
  end

  def unpublish
    @rotum.published = false
    @rotum.save

    redirect_to @rotum, notice: "Rota unpublished"
  end
end
