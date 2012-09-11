class UsersController < ApplicationController
  before_filter :authenticate_user!
  authorize_actions_for User, actions: { revive: :destroy }

  def index
    deleted = params[:deleted] || false
    if deleted
      @users = User.deleted.includes(:roles)
    else
      @users = User.not_deleted.includes(:roles)
    end
  end

  def show
    @user = User.find(params[:id])
  end

  def new
    @user = User.new
  end

  def edit
    @user = User.find(params[:id])
  end

  def create
    @user = User.new(params[:user])

    if @user.save
      redirect_to @user, notice: 'User was successfully created.'
    else
      render :new
    end
  end

  def update
    @user = User.find(params[:id])
    if @user.update_attributes(params[:user])
      redirect_to @user, notice: 'User was successfully updated.'
    else
      render :edit
    end
  end

  def destroy
    @user = User.find(params[:id])
    @user.destroy

    redirect_to users_url, notice: "#{@user.name}'s account was suspended"
  end

  def revive
    @user = User.find(params[:id])
    @user.revive

    redirect_to users_url(deleted: true), notice: "#{@user.name}'s account was revived"
  end
end
