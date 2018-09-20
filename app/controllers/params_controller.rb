class ParamsController < ApplicationController
  def logging
    @headers_filtered =
      request.env.select {|k,v|
        k.match("^HTTP.*|^CONTENT.*|^REMOTE.*|^REQUEST.*|^AUTHORIZATION.*|^SCRIPT.*|^SERVER.*")
      }
      .except("HTTP_COOKIE")
      .map { |k, v| "#{k}: #{v}" }
  end

  def ok
    render json: { success: true }, status: :ok
  end

  def fail
    render json: { success: false, error_code: 'INVALID_RESPONSE' }, status: 404
  end
end
