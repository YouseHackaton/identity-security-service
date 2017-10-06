class UsersController < ApplicationController
  def edit
    @user = User.find(:id)
  end

  def update
    @user = User.find(:id)
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
