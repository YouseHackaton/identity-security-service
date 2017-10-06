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
        @user.complete_step(:document)
        redirect_to :document_number_documents, notice: "Es un documento valido."
      else
        flash[:warning] = "No es un documento valido."
        render :edit
      end


    end
  end

  def document_number
    user
    @document_number = user.request_logs.document.order(created_at: :desc).first.request_content['number'][0..-4]
  end

  def update_document_number
    document = user.request_logs.document.order(created_at: :desc).first
    validation_for_continue = document.request_content['number'].last(3) == user_document_params[:document_number]

    if validation_for_continue
      user.request_logs.create(
        { request_type: :document_number, request_content: user_document_params }
      )

      @user.complete_step(:document_number)
      redirect_to :linked_in, notice: "Número de documento es correcto."
    else
      @document_number = document.request_content['number'][0..-4]

      flash[:warning] = "Número de documento no coincide."
      render :document_number
    end
  end

  private

  def user
    @user ||= current_user
  end

  def user_params
    params.require(:user).permit(:document_front_side, :document_back_side)
  end

  def user_document_params
    params.require(:user).permit(:document_number)
  end
end
