class UsersController < ApplicationController
  def new
    @user = User.new
  end

  def create
    @user = User.new(user_params)
    if @user.save
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
