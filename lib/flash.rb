require 'json'
require 'byebug'

class Flash

  attr_accessor :flash_now, :flash

  def initialize(req)
    if req.cookies['_tracks_app_flash']
      @flash = JSON.parse(req.cookies['_tracks_app_flash'])
    else
      @flash = {}
    end
    @old_flash = @flash
  end

  def [](key)
    self.flash[key.to_s]
  end

  def []=(key,val)
    self.flash[key.to_s] = val
  end

  def store_flash(res)
    new_flash = self.flash
    @old_flash.each do |k,v|

    end
    cookie = {path: "/", value: JSON.generate(self.flash)}
    res.set_cookie('_tracks_app_flash', cookie)
  end



end
