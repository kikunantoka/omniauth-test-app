Rails.application.config.middleware.use OmniAuth::Builder do
  provider :twitter, ENV['TWITTER_KEY'], ENV['TWITTER_SECRET']
  provider :moves, ENV['MOVES_KEY'], ENV['MOVES_SECRET']
end