class UsersController < ApplicationController
  before_action :authenticate_user!

  def edit
    @user = current_user
  end

  def update
    @user = current_user
    if @user.update_attributes(user_params)
      redirect_to :new_user, notice: 'Validaciones Ok!'
    else
      render :new
    end
  end

  private

  def user_params
    params.require(:user).permit(:profile_pic, :id_front_side, :id_back_side)
  end
end
