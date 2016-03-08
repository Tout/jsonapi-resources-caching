require 'jsonapi-resources'
require 'jsonapi-resources/caching'
require 'jsonapi-resources/caching/version'

module JSONAPI
  module ActsAsResourceController
    include JSONAPI::Caching

  end
end
