class ParamsController < ApplicationController

protect_from_forgery except: :any, prepend: true

  def logging
    check_auth!
    @path = results[:path]
    @params = results[:params]
    @headers_filtered = results[:headers].map { |k, v| "#{k}: #{v}" }
    @data = read
  end

  def any
    notify results
    push_value results

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
      params: request.query_parameters,
      headers: headers_filtered,
    }
  end

  def headers_filtered
    headers_hsh = request.headers.env.select &select_rule

    return headers_hsh if params[:with_cookies]
    headers_hsh.except("HTTP_COOKIE", "rack.request.cookie_string")
  end

  def select_rule
    if params[:not_matched]
      ->(_, v) { v.is_a? String }
    else
      lambda do |k, _|
        k.match("^HTTP.*|^CONTENT.*|^REMOTE.*|^REQUEST.*|^AUTHORIZATION.*|^SCRIPT.*|^SERVER.*")
      end
    end
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

  def cache
    @cache ||= Rails.cache #ActiveSupport::Cache::RedisCacheStore.new(expires_in: 10.seconds)
  end

  def store(array)
    cache.write('hist', array, expires_in: 100.hours)
  end

  def read
    cache.fetch('hist') { [] }
  end

  def push_value(hash)
    array = read
    array.pop while array.length >= 5
    array.unshift hash
    store array
  end
end
