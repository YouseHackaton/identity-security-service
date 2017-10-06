class UsersController < ApplicationController
  before_action :authenticate_user!

  def edit
    user
  end

  def update
    if user.update_without_password(user_params)
      validator = ImagesValidator.new
      publicly_exposed_person = validator.recognized_face? selfie: user.selfie.path

      validation_for_continue = !publicly_exposed_person[:valid?]

      if validation_for_continue
        user.request_logs.create(
          { request_type: :picture, request_content: publicly_exposed_person[:data] },
        )
      end

      @user.complete_step(:selfie)
      redirect_to :edit_documents, notice: "Validaciones #{validation_for_continue ? ';)' : ':('}"
    else
      render :edit
    end
  end

  private

  def user
    @user ||= current_user
  end

  def user_params
    params.require(:user).permit(:selfie)
  end
end
