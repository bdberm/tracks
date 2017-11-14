require 'rack'
require_relative '../../lib/controller_base'
require_relative '../../lib/router'
require_relative '../../lib/show_exceptions'

router = Router.new
router.draw do
end
