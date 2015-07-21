require 'jwt'

class SessionsController < ApplicationController

  def new
  end

  def create
    user = User.find_by(email: params[:session][:email].downcase)
    if user && user.authenticate(params[:session][:password])
      sign_in user
      redirect_back_or user
    else
      flash.now[:error] = 'Invalid email/password combination'
      render 'new'
    end
  end

  def destroy
    sign_out
    redirect_to root_url
  end

  def get_token
    exp = Time.now.to_i + 4 * 3600
    print(current_user)
    payload = {:id => current_user.id, :exp => exp }
    hmac_secret = 'your secret key'
    token = JWT.encode payload, hmac_secret, 'HS256'
    render :json => {:token => token }
  end

end


class SampleController < ApplicationController
  def index

    if params.key?(:name) || params.key?(:pass)
      @msg = 'Logged in as ' + params[:name]
      @token = token
    end

  end
  protect_from_forgery with: :null_session
end