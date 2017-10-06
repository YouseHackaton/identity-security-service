class UsersController < ApplicationController
  before_action :authenticate_user!

  def edit
    @user = current_user
  end

  def update
    @user = current_user
    byebug
    if @user.update_attributes(user_params)
      validator = ImagesValidator.new


      validator.valid_document? document_front_side: front_image_path, document_back_side: back_image_path
      redirect_to :new_user, notice: 'Validaciones Ok!'
    else
      render :new
    end
  end

  private

  def user_params
    params.require(:user).permit(:selfie, :document_front_side, :document_back_side)
  end
end
