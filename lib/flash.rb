require 'json'
require 'byebug'

class Flash

  attr_accessor :now

  def initialize(req)
    @now = req.cookies['_tracks_app_flash'] ? JSON.parse(req.cookies['_tracks_app_flash']) : {}
    @for_next_session = {}
  end

  #[] method will show @now value if available, so flash saved from previous response
  #as well as anything added to now is still available in the lifecycle of the controller
  def [](key)
    @now[key] || @now[key.to_s] || @for_next_session[key] || @for_next_session[key.to_s]
  end

  def []=(key,val)
    @for_next_session[key] = val
  end

  def store_flash(res)
    cookie = {path: "/", value: JSON.generate(@for_next_session)}
    res.set_cookie('_tracks_app_flash', cookie)
  end

end
