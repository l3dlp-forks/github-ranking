class TokenRegisterJob < ActiveJob::Base
  queue_as :default

  def perform(user_id, token)
    register_token(user_id, token)
    AccessToken.fetch_rate_limit(token)
  end

  private

  def register_token(user_id, token)
    access_token = AccessToken.where(user_id: user_id).first_or_create(token: token)
    access_token.update(token: token) if access_token.token != token
  end
end
