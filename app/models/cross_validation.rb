class CrossValidation
  attr_reader :facebook_info
  attr_reader :linkedin_info
  attr_reader :document_info
  attr_reader :user

  def initialize(user)
    @user = user
    @facebook_info = user.last_log(:facebook).request_content
    @linkedin_info = user.last_log(:linkedin).request_content
    @document_info = user.last_log(:document).request_content
  end

  def intersect
    social_intersect = facebook_info.to_s.split(/\W+/) & linkedin_info.to_s.split(/\W+/)
    cross_validation_array = social_intersect.each(&:upcase!) & document_info.to_s.split(/\W+/)
    cross_validation_array.count > 2 ? true : false
  end
end
