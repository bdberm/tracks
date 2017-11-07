require 'json'

class Session
  #find cookie if it exits and deserialize into hash
  def initialize(req)
    if req.cookies['_tracks_app']
      @cookies = JSON.parse(req.cookies['_tracks_app'])
    else
      @cookies = {}
    end
  end

  def [](key)
    @cookies[key]
  end

  def []=(key, val)
    @cookies[key] = val
  end

  #add new cookie to response with deserialized JSON
  #set path to "/" to make cookie universal to whole site
  def store_session(res)
    cookie = {path: "/", value: JSON.generate(@cookies)}
    res.set_cookie('_tracks_app', cookie)
  end
end
