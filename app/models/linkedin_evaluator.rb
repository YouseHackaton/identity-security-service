class LinkedinEvaluator
  attr_accessor :client
  attr_reader :user

  BASIC_PROFILE_FIELDS = ['headline', 'positions', 'first_name', 'last_name', 'industry']

  def initialize(user)
    @user = user
    credential = user.credentials.find_by_provider('linkedin')
    tokens = credential.token.split(' ')
    @client = LinkedIn::Client.new(ENV['LINKEDIN_KEY'], ENV['LINKEDIN_SECRET'])
    @client.authorize_from_access(tokens[1], tokens[0])
  end

  def get_profile_fields
    client.profile(fields: BASIC_PROFILE_FIELDS).as_json
  end

  def save
    user.request_logs.create(
      request_type: :linkedin,
      request_content: get_profile_fields
    )
  end

end
