require 'json'
require 'byebug'

class Flash

  attr_accessor :flash_now

  def initialize(req)
    if req.cookies['_rails_lite_app_flash']
      @old_flash = JSON.parse(req.cookies['_rails_lite_app_flash'])
    else
      @old_flash = {}
    end
    @flash = @old_flash
    @flash_now = {}

  end

  def [](key)
    @flash[key.to_s] || @flash_now[key.to_s]
  end

  def []=(key, val)

    @flash[key.to_s] = val
  end

  def store_flash(res)
    to_persist = {}

    @flash.each do |k,v|
      to_persist[k] = v unless @old_flash.has_key?(k)
    end

    persist = @flash.reject {|k,v| @old_flash.include?(k)}

    res.set_cookie('_rails_lite_app_flash', {value: JSON.generate(@persist), path: "/"})

  end

  def now=(key, val)
    @flash_now[key] = val

  end



end
