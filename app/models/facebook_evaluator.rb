require 'koala'

class FacebookEvaluator
  attr_reader :user
  attr_accessor :messages
  attr_accessor :response_body
  RELATIONS = [:posts, :tagged_places, :family, :feed, :albums]
  CONNECTION_SCORES = { posts: 10, tagged_places: 30, family: 30, albums: 20, feed: 10 }
  CONNECTION_LIMITS = { posts: 30, tagged_places: 10, family: 5, albums: 10, feed: 50 }
  FINANCE_UNLIKED_PHRASES = [
    "ESTOY BUSCANDO TRABAJO",
    "PERDI MI EMPLEO",
    'BUSCANDO TRABAJO',
    'BUSCO TRABAJO'
  ]

  def initialize(user)
    @user = user
    @graph ||= Koala::Facebook::API.new(user.credentials.find_by(provider: 'facebook').token)
    @messages = []
    @response_body = {
      profile: get_profile_info
    }
  end

  def calculate_score
    RELATIONS.inject(0) do |accum, relation|
      response = @graph.get_connections(:me, relation, { limit: CONNECTION_LIMITS[relation] })
      response_body[relation] = response
      value = response.count
      messages.push "#{relation} score #{value} performance: #{(value / CONNECTION_LIMITS[relation].to_f)}"
      accum + ((value / CONNECTION_LIMITS[relation].to_f) * CONNECTION_SCORES[relation])
    end
  end

  def possible_finance_trouble?
    posts = @graph.get_connections(:me, :posts, {limit: 50})
    messages = posts.map{ |x| x["message"].upcase }
    result = messages & FINANCE_UNLIKED_PHRASES
    return true if result.size > 0
    false
  end

  def save
    calculate_score if messages.empty?
    user.request_logs.create(
      request_type: :facebook,
      request_content: response_body
    )
  end

  private

  def get_profile_info
    @graph.get_object("me",fields: [:name, :first_name, :last_name])
  end
end
