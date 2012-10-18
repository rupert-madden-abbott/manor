class UsersController < ApplicationController
  before_filter :authenticate_user!

  load_and_authorize_resource

  def index
    @users = @users.order(:name)
    @users = if can? :manage, User
      @users.includes(:roles)
    else
      @users.all
    end

    if params[:filters].present?
      Array.wrap(params[:filters]).each do |filter|
        @users = @users.send(filter)
      end
    end
  end

  def show
  end

  def new
  end

  def edit
  end

  def create
    if @user.save
      redirect_to @user, notice: "Created #{@user}"
    else
      render :new
    end
  end

  def update
    if @user.update_attributes(params[:user])
      redirect_to @user, notice: "Updated #{@user}"
    else
      render :edit
    end
  end

  def destroy
    @user.destroy

    redirect_to users_url, notice: "Archived #{@user}'s account"
  end

  def revive
    @user.revive

    redirect_to users_url(deleted: true), notice: "Revived #{@user}'s account"
  end
end
