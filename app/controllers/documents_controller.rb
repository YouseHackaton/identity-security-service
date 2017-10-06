class DocumentsController < ApplicationController
  before_action :authenticate_user!

  def edit
    user
  end

  def update
    if user.update_without_password(user_params)
      validator = ImagesValidator.new
      document = validator.valid_document? document_front_side: user.document_front_side.path, document_back_side: user.document_back_side.path
      validation_for_continue = document[:valid?]

      if validation_for_continue
        user.request_logs.create(
          { request_type: :document, request_content: document[:data] }
        )
      end

      @user.complete_step(:document)
      redirect_to :linked_in, notice: "Validaciones #{validation_for_continue ? ';)' : ':('}"
    end
  end

  private

  def user
    @user ||= current_user
  end

  def user_params
    params.require(:user).permit(:document_front_side, :document_back_side)
  end
end
