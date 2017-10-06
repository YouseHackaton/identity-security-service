class SocialsController < ApplicationController
  def linkedin
    current_user.credentials.find_or_initialize_by(provider: 'linkedin') do |credential|
      credential.provider = 'linkedin'
      credential.token = "#{request.env['omniauth.auth'].credentials.secret} #{request.env['omniauth.auth'].credentials.token}"
      credential.save
    end
    current_user.complete_step(:linkedin)
    current_user.complete_step(:evaluation)
    redirect_to :results
  end
end
