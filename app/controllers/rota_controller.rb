class RotaController < ApplicationController
  before_filter :authenticate_user!
  authorize_actions_for Rotum, actions: { assign: :update, unassign: :update }

  def index
    @rota = Rotum.all
  end

  def show
    @rotum = Rotum.find_relative(params[:id])
    @next_rotum = Rotum.next(@rotum)
    @previous_rotum = Rotum.previous(@rotum)
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

    @rotum.duties.each do |duty|
      last_selected = nil
      selected = @users.shuffle.min_by do |user|
        duty_count = user.duties.size + user.duties.select { |duty| duty.day.saturday? || duty.day.sunday? }.count + user.duties.select { |duty| duty.day.sunday? }.count
        if user.preferences.scoped.where(duty_id: duty.id).first || user == last_selected
          duty_count += 5000
        end
        duty_count
      end
      selected.duties << duty
      last_selected = selected
    end

    @rotum.assigned = true
    @rotum.save

    redirect_to rotum_url(@rotum)
  end

  def unassign
    @rotum = Rotum.includes(:duties).find(params[:id])
    @rotum.duties.each { |duty| duty.users.clear }
    @rotum.assigned = false
    @rotum.save

    redirect_to rotum_url(@rotum)
  end
end
