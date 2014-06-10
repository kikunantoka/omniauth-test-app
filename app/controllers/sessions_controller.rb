class SessionsController < ApplicationController

  def zaim
    @zaim = OAuth::Consumer.new(ENV['ZAIM_KEY'], ENV['ZAIM_SECRET'],
                                request_token_path: ENV['ZAIM_REQUEST_TOKEN_URL'],
                                authorize_path: ENV['ZAIM_AUTHORIZE_URL'],
                                access_token_path: ENV['ZAIM_ACCESS_TOKEN_URL'])
    request_token = @zaim.get_request_token( { oauth_callback: ENV['ZAIM_CALLBACK_URL'] })

    session[:oauth_token] = request_token.token
    session[:oauth_token_secret] = request_token.secret

    redirect_to request_token.authorize_url
  end

  def zaim_callback
    @zaim = OAuth::Consumer.new(ENV['ZAIM_KEY'], ENV['ZAIM_SECRET'],
                                request_token_path: ENV['ZAIM_REQUEST_TOKEN_URL'],
                                authorize_path: ENV['ZAIM_AUTHORIZE_URL'],
                                access_token_path: ENV['ZAIM_ACCESS_TOKEN_URL'])
    request_token = OAuth::RequestToken.new(
    @zaim,
    session[:oauth_token],
    session[:oauth_token_secret])

    @access_token = request_token.get_access_token(
      {},:oauth_verifier => params[:oauth_verifier])

    session[:oauth_token] = session[:oauth_token_secret] = nil

    redirect_to root_path
  end

  def callback
    auth = request.env['omniauth.auth']

    session[:user_id] = auth['uid']
    session[:name] = auth['info']['name']
    session[:oauth_token] = auth['credentials']['token']
    session[:oauth_token_secret] = auth['credentials']['secret']

    redirect_to root_path
  end

  def destroy
    reset_session
    redirect_to root_path
  end

  # def callback
  #   auth = request.env['omniauth.auth']
  #   user = User.find_by_provider_and_uid(auth['provider'], auth['uid']) || User.create_with_omniauth(auth)
  #   session[:user_id] = user.id
  #   redirect_to root_path
  # end

  # def destroy
  #   session[:user_id] = nil
  #   redirect_to root_path
  # end
end