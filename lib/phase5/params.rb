require 'uri'

module Phase5
  class Params
    # use your initialize to merge params from
    # 1. query string
    # 2. post body
    # 3. route params
    #
    # You haven't done routing yet; but assume route params will be
    # passed in as a hash to `Params.new` as below:
    def initialize(req, route_params = {})
      @route_params = route_params
      query_expression = parse_www_encoded_form(req.query_string)
      body_expression = parse_www_encoded_form(req.query_string)
      Params.hash_merge(query_expression, body_expression)
      @params = query_expression ? query_expression : parse_www_encoded_form(req.body)
      @params ||= @route_params
    end

    def self.hash_merge(h, g)
      h && g ? h.merge(g) : h ||= g
    end

    def [](key)
      if @params.select { |k, v| k == key.to_s }.first
        @params.select { |k, v| k == key.to_s }.first.last
      else
        @params.select { |k, v| k == key.to_sym }.first.last
      end
    end

    # this will be useful if we want to `puts params` in the server log
    def to_s
      @params.to_s
    end

    class AttributeNotFoundError < ArgumentError; end;

    private
    # this should return deeply nested hash
    # argument format
    # user[address][street]=main&user[address][zip]=89436
    # should return
    # { "user" => { "address" => { "street" => "main", "zip" => "89436" } } }
    def parse_www_encoded_form(www_encoded_form)
      return nil if !www_encoded_form
      settings = www_encoded_form.split("&")
      pairs = settings.map { |setting| setting.split("=") }
      assignments = pairs.to_h
      current_params = {}
      assignments.each do |key, v|
        keys = parse_key(key)
        set_nested_hash(keys, current_params, v)
      end
      current_params
    end

    def set_nested_hash(keys, hash, value)
      if keys.size == 1
        hash[keys.first] = value
      elsif hash[keys.first]
        set_nested_hash(keys[1..-1], hash[keys.first], value)
      else
        hash[keys.first] = {}
        set_nested_hash(keys[1..-1], hash[keys.first], value)
      end
    end


    # this should return an array
    # user[address][street] should return ['user', 'address', 'street']
    def parse_key(key)
      key.split(/\]\[|\[|\]/)
    end
  end
end
