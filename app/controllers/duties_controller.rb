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
  end

  def edit
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
    Duty.where(id: params[:ids]).each do |duty|
      duty.take(current_user)
    end

    redirect_to rotum_duties_path(@rotum), notice: "These duties have been assigned to you"
  end

  private
  def find_relative_rotum
    @rotum = Rotum.find_by_relative(params[:rotum_id], current_user)
    @duties = @rotum.duties
  end
end
