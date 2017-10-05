class User < ApplicationRecord
  mount_uploader :profile_pic, AvatarUploader

  validates :profile_pic, guard: {
    safe_search: true,
    face_detection: true,
    tool: :carrierwave
  }

  validates :profile_pic, :id_front_side, :id_back_side, presence: true
end
