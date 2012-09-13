class RotaController < ApplicationController
  before_filter :authenticate_user!
  authorize_actions_for Rotum, actions: { assign: :update, unassign: :update, publish: :update, unpublish: :update }

  def index
    @rota = Rotum.all
  end

  def show
    @rotum = Rotum.find_relative(params[:id])
    @next_rotum = Rotum.next(@rotum)
    @previous_rotum = Rotum.previous(@rotum)

    if @rotum.blank?
      redirect_to rota_path, notice: "Rota does not exist"
    end
  end

  def new
    @rotum = Rotum.new
  end

  def edit
    @rotum = Rotum.find(params[:id])
  end

  def create
    @rotum = Rotum.new(params[:rotum])

    if @rotum.create_with_duties
      redirect_to @rotum, notice: 'Rotum was successfully created.'
    else
      render :new
    end
  end

  def update
    @rotum = Rotum.find(params[:id])
    if @rotum.update_attributes(params[:rotum])
      redirect_to @rotum, notice: 'Rotum was successfully updated.'
    else
      render :edit
    end
  end

  def destroy
    @rotum = Rotum.find(params[:id])
    @rotum.destroy

    redirect_to rota_url
  end

  def assign
    @rotum = Rotum.includes(:duties).find(params[:id])
    @users = User.for_assignment
    @duties = @rotum.duties

    last_selected = nil
    @duties.each do |duty|
      selected = @users.min_by do |user|
        [
          user.preferences.where(duty_id: duty).present? ? 1 : 0,
          user == last_selected ? 1 : 0,
          user.duty_weight,
          user.duties.size,
          -user.preferences.size
        ]
      end

      selected.duties << duty
      last_selected = selected
    end

    @rotum.assigned = true
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
    @rotum = Rotum.find(params[:id])
    @rotum.published = true
    @rotum.save

    redirect_to @rotum, notice: "Rota published"
  end

  def unpublish
    @rotum = Rotum.find(params[:id])
    @rotum.published = false
    @rotum.save

    redirect_to @rotum, notice: "Rota unpublished"
  end
end
