require 'koala'

class FacebookEvaluator
  attr_reader :user
  attr_accessor :messages
  RELATIONS = [:posts, :tagged_places, :family, :feed, :albums]
  CONNECTION_SCORES = { posts: 10, tagged_places: 30, family: 30, albums: 20, feed: 10 }
  CONNECTION_LIMITS = { posts: 30, tagged_places: 10, family: 5, albums: 10, feed: 50 }

  def initialize(user)
    @user = user
    @graph ||= Koala::Facebook::API.new(user.credentials.find_by(provider: 'facebook').token)
    @messages = []
  end

  def calculate_score
    RELATIONS.inject(0) do |accum, relation|
      value = @graph.get_connections(:me, relation, { limit: CONNECTION_LIMITS[relation] }).count
      messages.push "#{relation} score #{value} performance: #{(value / CONNECTION_LIMITS[relation].to_f)}"
      accum + ((value / CONNECTION_LIMITS[relation].to_f) * CONNECTION_SCORES[relation])
    end
  end

  def get_profile_info
    @graph.get_object("me",fields: [:name, :first_name, :last_name])
  end
end
