module FormattingHelpers

  def format_date(date)
    date.strftime("%d %b %Y %H:%M")
  end

end

module AuthenticationHelpers
  def protected!
    unless authorized?
      response['WWW-Authenticate'] = %(Basic realm="Yarbe Authentication")
      throw(:halt, [401, "Not authorized\n"])
    end
  end

  def authorized?
    @auth ||=  Rack::Auth::Basic::Request.new(request.env)
    @auth.provided? && @auth.basic? && @auth.credentials && @auth.credentials == Config.admin_credentials
  end
end