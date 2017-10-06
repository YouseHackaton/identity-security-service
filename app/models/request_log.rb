class RequestLog < ApplicationRecord
  enum request_type: { picture: 0, document: 1, facebook: 2, linkedin: 3, document_number: 4 }

  belongs_to :user

  validates :request_type, presence: true
end
