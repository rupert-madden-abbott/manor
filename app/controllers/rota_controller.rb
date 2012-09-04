class RotaController < ApplicationController
  before_filter :authenticate_user!
  authorize_actions_for Rotum, actions: { assign: :update, unassign: :update }
  def index
    @rota = Rotum.all
  end

  def show
    if params[:id] == 'current'
      @rotum = Rotum.current
    else
      @rotum = Rotum.find(params[:id])
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

    if @rotum.valid?
      dates = (@rotum.starts..@rotum.ends).to_a
      holidays = Holiday.find(:all, conditions: ["day IN (?)", dates])
      holidays.each do |holiday|
        dates.delete(holiday.day)
        @rotum.duties.build day: holiday.day, starts: holiday.duty_starts, ends: holiday.duty_ends
      end

      dates.each do |date|
        if date.saturday?
          @rotum.duties.build day: date, starts: time(12), ends: time(7)
        elsif date.sunday?
          Rails.logger.error time(8)
          @rotum.duties.build day: date, starts: time(8), ends: time(17)
          @rotum.duties.build day: date, starts: time(17), ends: time(7)
        else
          @rotum.duties.build day: date, starts: time(19), ends: time(7)
        end
      end

      @rotum.save

      redirect_to @rotum, notice: 'Rotum was successfully created.'
    else
      render action: "new"
    end
  end

  def update
    @rotum = Rotum.find(params[:id])

    if @rotum.update_attributes(params[:rotum])
      redirect_to @rotum, notice: 'Rotum was successfully updated.'
    else
      render action: "edit"
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
      selected = @users.shuffle.min_by do |user|
        has_preference = user.preferences.select do |preference|
          preference.duty_id = duty.id
        end.present?
        if has_preference
          5000 + user.duties.size
        else
          user.duties.size
        end
      end
      selected.duties << duty
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
