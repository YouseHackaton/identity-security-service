class UsersController < ApplicationController
  before_action :authenticate_user!

  def edit
    user
  end

  def update
    if user.update_without_password(user_params)
      validator = ImagesValidator.new
      document = validator.valid_document? document_front_side: user.document_front_side.path, document_back_side: user.document_back_side.path
      publicly_exposed_person = validator.recognized_face? selfie: user.selfie.path

      validation_for_continue = !publicly_exposed_person[:valid?] && document[:valid?]

      if validation_for_continue
        user.request_logs.create([
          { request_type: :picture, request_content: publicly_exposed_person[:data] },
          { request_type: :document, request_content: document[:data] }
        ])
      end

      redirect_to :edit_users, notice: "Validaciones #{validation_for_continue ? ';)' : ':('}"
    else
      render :edit
    end
  end

  private

  def user
    @user ||= current_user
  end

  def user_params
    params.require(:user).permit(:selfie, :document_front_side, :document_back_side)
  end
end
