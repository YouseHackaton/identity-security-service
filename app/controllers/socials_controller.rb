class SocialsController < ApplicationController
  def linkedin
    current_user.credentials.find_or_initialize_by(provider: 'linkedin') do |credential|
      credential.provider = 'linkedin'
      credential.token = "#{request.env['omniauth.auth'].credentials.secret} #{request.env['omniauth.auth'].credentials.token}"
      credential.save
    end
    @user.complete_step(:linkedin)
    redirect_to :results
  end
end
