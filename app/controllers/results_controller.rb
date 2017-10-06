class ResultsController < ApplicationController
  before_action :authenticate_user!

  def index
     @steps = user.journey
     fb_evaluator = FacebookEvaluator.new(user)
     @percentage_fb = fb_evaluator.calculate_score
  end

  private

  def user
    @user ||= current_user
  end
end
