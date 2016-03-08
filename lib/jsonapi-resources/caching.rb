
module JSONAPI
  module Caching
    @@caching_options = {}

    def process_request
      @request = JSONAPI::Request.new(params, context: context,
                                      key_formatter: key_formatter,
                                      server_error_callbacks: (self.class.server_error_callbacks || []))
      unless @request.errors.empty?
        render_errors(@request.errors)
      else
        render_options = action_cacher do
          operation_results = create_operations_processor.process(@request)
          prepare_results(operation_results)
        end
        render_results(render_options)
      end

    rescue => e
      handle_exceptions(e)
    ensure
      if response.body.size > 0
        response.headers['Content-Type'] = JSONAPI::MEDIA_TYPE
      end
    end

    def action_cacher(&block)
      action_cache_key = send(action_caching_options[:cache_key_method])
      action_cache_expiration = send(action_caching_options[:cache_expiration_method]) || {}

      if action_cache_key && action_cache_expiration
        Rails.cache.fetch(action_cache_key, expires_in: action_cache_expiration) do
          block.call
        end
      elsif action_cache_key
        Rails.cache.fetch(action_cache_key) do
          block.call
        end
      else
        block.call
      end
    end

    def self.cached_action(action, options={})
      action_cache_key_method = options[:with_cache_key] || :default_cache_key
      action_cache_expiration_method = options[:with_cache_expiration] || :default_cache_expiration

      controller_key = self.to_s.gsub('::','/').underscore.gsub('_controller', '')

      @@caching_options ||= {}.with_indifferent_access
      @@caching_options[controller_key] ||= {}.with_indifferent_access
      @@caching_options[controller_key][action] ||= {}.with_indifferent_access
      @@caching_options[controller_key][action][:cache_key_method] = action_cache_key_method
      @@caching_options[controller_key][action][:cache_expiration_method] = action_cache_expiration_method

    end

    def default_cache_expiration
    end

    def default_cache_key
      params.to_a.sort_by{|k,v| k}.map {|k,v| k.to_s + '-' + v.to_s}*'_'
    end

    def action_caching_options
      @action_caching_options ||= @@caching_options[params[:controller]].try(:[], params[:action])
    end

    def render_results(render_options)
      render(render_options)
    end

    def prepare_results(operation_results)
      response_doc = create_response_document(operation_results)

      render_options = {
        status: response_doc.status,
        json:   response_doc.contents
      }

      render_options[:location] = response_doc.contents[:data]["links"][:self] if (
        response_doc.status == :created && response_doc.contents[:data].class != Array
      )
      return render_options
    end

  end
end
