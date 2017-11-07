require 'json'
require 'byebug'

class Flash

  attr_accessor :now

  def initialize(req)
    #save previous flash value to @now so they are still available
    #within lifecycle of the existing request and we can set @for_next_session
    #empty to only store flash cookie of any newly set flash values we want to persist
    #to next request-resonse cycle
    @now = req.cookies['_tracks_app_flash'] ? JSON.parse(req.cookies['_tracks_app_flash']) : {}
    @for_next_session = {}
  end

  #[] method will show @now value if available, so flash saved from previous response
  #as well as anything added to now is still available in the lifecycle of the controller
  #check for string value of keys as anything pulled into now from old cookie will have string keys
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
