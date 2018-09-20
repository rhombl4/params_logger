class ParamsController < ApplicationController
  def logging
    check_auth!
    @path = results[:path]
    @params = results[:params]
    @headers_filtered = results[:headers].map { |k, v| "#{k}: #{v}" }
  end

  def any
    notify results

    if params[:success] == 'false'
      render json: { success: false, error_code: 'INVALID_RESPONSE' }, status: 404
    else
      render json: { success: true }, status: :ok
    end
  end

  def auth; end

  def check_auth
    if credentials_valid?
      set_auth!
      redirect_to session[:url] || root_path
    else
      redirect_to action: :auth
    end
  end

  private

  def notify(message = '')
    ActionCable.server.broadcast "cb_notifications", message: message
  end

  def results
    { 
      time: DateTime.now.rfc822,
      path: request.path,
      params: params,
      headers: headers_filtered,
    }
  end

  def headers_filtered
    request.env.select do |k,v|
      k.match("^HTTP.*|^CONTENT.*|^REMOTE.*|^REQUEST.*|^AUTHORIZATION.*|^SCRIPT.*|^SERVER.*")
    end.except("HTTP_COOKIE")
  end

  def check_auth!
    return if session[:auth]
    session[:url] = request.url
    redirect_to action: :auth
  end

  def credentials_valid?
    params[:login] == 'password' &&
      params[:password] == 'login'
  end

  def set_auth!
    session[:auth] = true
  end
end
