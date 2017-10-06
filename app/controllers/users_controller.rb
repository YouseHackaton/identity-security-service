class UsersController < ApplicationController
  before_action :authenticate_user!

  def edit
    user
  end

  def update
    if user.update_without_password(user_params)
      validator = ImagesValidator.new

      is_a_face = validator.is_a_face? selfie: user.selfie.path

      if is_a_face[:valid?]
        publicly_exposed_person = validator.recognized_face? selfie: user.selfie.path

        if publicly_exposed_person[:valid?]
          flash[:warning] = "¿Eres una persona publicamente expuesta?, por favor comunicate con nosotros."
          render :edit
        else
          user.request_logs.create(
            request_type: :picture, request_content: {
              descriptions: publicly_exposed_person[:data],
              faces: is_a_face[:data]

            }
          )
          @user.complete_step(:selfie)
          redirect_to :edit_documents, notice: "Muy buena selfie :)"
        end
      else
        flash[:warning] = "No pudimos identificar un rostro en la imagen, por favor intenta de nuevo."
        render :edit
      end
    else
      flash[:warning] = "Intenta nuevamente."
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
