class HomeController < BaseController
  before_action :login_required, only: [:tweet, :follow, :follow_check]

  def index
  end

  # 定型文をつぶやく
  def tweet
    # text = sprintf(Settings.tweet_setting.text, Time.now)
    text = "test"
    twitter_client.update(text)
    flash[:notice] = "tweet: #{text}"
    redirect_to root_path
  end

  # 特定ユーザをフォローする
  # def follow
  #   twitter_client.follow(Settings.tweet_setting.follow_target_name)
  #   flash[:notice] = "follow done"
  #   redirect_to root_path
  # end

  # 特定ユーザをフォローしているかどうかチェックする
  # def follow_check
  #   follow_info = twitter_client.friendships(Settings.tweet_setting.follow_target_name).first
  #   flash[:notice] = "follow check: #{follow_info['connections'].include?('following')}"
  #   redirect_to root_path
  # end

  private
  def twitter_client

    Twitter::REST::Client.new do |config|
      config.consumer_key        = ENV['TWITTER_KEY']
      config.consumer_secret     = ENV['TWITTER_SECRET']
      config.access_token        = @current_user.token
      config.access_token_secret = @current_user.secret
    end

  end

end