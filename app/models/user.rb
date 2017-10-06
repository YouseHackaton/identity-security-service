class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :recoverable, :rememberable,
         :omniauthable, :trackable, :validatable, :omniauth_providers => [:facebook]

  mount_uploader :selfie, PictureUploader
  mount_uploader :document_front_side, PictureUploader
  mount_uploader :document_back_side, PictureUploader

  has_many :request_logs

  validates :selfie, guard: {
    safe_search: true,
    face_detection: true,
    tool: :carrierwave
  }, on: :update

  validates :selfie, :document_front_side, :document_back_side, presence: true, on: :update

  def self.from_omniauth(auth)
    where(provider: auth.provider, uid: auth.uid).first_or_create do |user|
      user.email = auth.info.email
      user.password = Devise.friendly_token[0,20]
      user.name = auth.info.name   # assuming the user model has a name
      user.image = auth.info.image # assuming the user model has an image
    end
  end
end
