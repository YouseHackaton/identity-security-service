class LinkedInController < ApplicationController
  def index
    current_user.complete_step(:linkedin)
  end
end
