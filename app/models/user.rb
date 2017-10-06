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
  has_many :credentials, dependent: :destroy

  def last_log(provider)
    request_logs.where(request_type: provider).order(created_at: :desc).first
  end

  def self.from_omniauth(auth)
    user = where(provider: auth.provider, uid: auth.uid).first_or_create do |user|
      user.email = auth.info.email
      user.password = Devise.friendly_token[0,20]
      user.name = auth.info.name   # assuming the user model has a name
      user.image = auth.info.image # assuming the user model has an image
    end.credentials.find_or_initialize_by(provider: auth.provider) do |credential|
      credential.provider = auth.provider
      credential.token = auth.credentials.token
      credential.expires_at = DateTime.parse(Time.at(auth.credentials.expires_at).to_s)
      credential.save
    end.user
  end
end
