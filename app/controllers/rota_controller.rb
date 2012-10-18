class RotaController < ApplicationController
  before_filter :authenticate_user!
  before_filter :find_relative_rotum, only: :show
  load_and_authorize_resource
  skip_load_resource only: [:assign, :unassign]

  def index
  end

  def show
    if @rotum.blank?
      redirect_to rota_path, notice: "Rota does not exist"
    end

    if can? :manage, @rotum
      @users = User.for_assignment.includes(preferences: { duty: :rotum } )
    end
  end

  def new
  end

  def edit
  end

  def create
    if @rotum.create_with_duties
      redirect_to @rotum, notice: 'Rotum was successfully created.'
    else
      render :new
    end
  end

  def update
    if @rotum.update_attributes(params[:rotum])
      redirect_to @rotum, notice: 'Rotum was successfully updated.'
    else
      render :edit
    end
  end

  def destroy
    @rotum.destroy

    redirect_to rota_url
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

  private

  def find_relative_rotum
    @rotum = Rotum.complete
    if can? :manage, @rotum
      @rotum = @rotum.admin
    end
    @rotum = case params[:id]
      when 'current'
        @rotum.current.first
      when 'next'
        @rotum.next.first
      when 'previous'
        @rotum.previous.first
      else
        @rotum.find(params[:id])
    end
  end
end
