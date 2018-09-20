class ParamsController < ApplicationController
  def logging
    @headers_filtered =
      request.env.select {|k,v|
        k.match("^HTTP.*|^CONTENT.*|^REMOTE.*|^REQUEST.*|^AUTHORIZATION.*|^SCRIPT.*|^SERVER.*")
      }
      .except("HTTP_COOKIE")
      .map { |k, v| "#{k}: #{v}" }
  end
end
