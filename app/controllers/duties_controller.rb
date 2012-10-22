class DutiesController < ApplicationController
  before_filter :authenticate_user!
  before_filter :find_relative_rotum, only: :index
  load_and_authorize_resource :rotum
  load_and_authorize_resource :duty, through: :rotum
  skip_load_resource only: :take

  respond_to :html

  def index
    if can? :manage, @rotum
      @users = User.for_assignment.includes(preferences: { duty: :rotum } )
    end
  end

  def show
    @users = User.on_rota
  end

  def new
    @users = User.on_rota.order(:name)
  end

  def edit
    @users = User.on_rota.order(:name)
  end

  def create
    @duty.save
    respond_with(@rotum, @duty)
  end

  def update
    @duty.update_attributes(params[:duty])
    respond_with(@rotum, @duty)
  end

  def destroy
    @duty.destroy
    respond_with(@rotum, @duty)
  end

  def take
    @duty = Duty.find(params[:id])
    @duty.take(current_user)
    respond_with(@rotum, @duty)
  end

  private
  def find_relative_rotum
    @rotum = Rotum.find_by_relative(params[:rotum_id], current_user)
    @duties = @rotum.duties
  end
end
