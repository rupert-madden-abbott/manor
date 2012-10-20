class UsersController < ApplicationController
  before_filter :authenticate_user!

  before_filter :load_users, only: :index
  load_and_authorize_resource

  def index
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

  private
  def load_users
    @users = User.filter_by(current_user, params[:filters])
  end
end
