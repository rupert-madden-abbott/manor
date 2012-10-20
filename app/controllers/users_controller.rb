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
    @user.save
    respond_with(@user)
  end

  def update
    @user.update_attributes(params[:user])
    respond_with(@user)
  end

  def destroy
    @user.destroy
    respond_with(@user)
  end

  def revive
    @user.revive

    redirect_to users_url(deleted: true), notice: "Revived #{@user}'s account"
  end
end
