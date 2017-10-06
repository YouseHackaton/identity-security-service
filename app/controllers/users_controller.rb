class UsersController < ApplicationController
  before_action :authenticate_user!

  def edit
    @user = current_user
  end

  def update
    @user = current_user

    if @user.update_without_password(user_params)
      validator = ImagesValidator.new
      document = validator.valid_document? document_front_side: @user.document_front_side.path, document_back_side: @user.document_back_side.path
      publicly_exposed_person = validator.wecognized_face? selfie: @user.selfie.path

      validation_for_continue = publicly_exposed_person[:valid?] && document[:valid?]

      redirect_to :edit_users, notice: "Validaciones #{validation_for_continue ? ';)' : ':('}"
    else
      render :new
    end
  end

  private

  def user_params
    params.require(:user).permit(:selfie, :document_front_side, :document_back_side)
  end
end
