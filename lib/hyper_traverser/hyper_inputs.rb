require_relative 'hyper_input'

module HyperTraverser
  class HyperInputs
    def initialize(inputs)
      @inputs = Hash[inputs.map do |k, v|
        [k, HyperInput.new(v)]
      end]
    end

    # TODO define methods
    def method_missing(method, *params)
      if method.to_s =~ /=$/ # setter
        key = method.to_s.chop
        if @inputs[key]
          @inputs[key].value = params[0]
        else
          raise "no input #{key}"
        end
      else # getter
        key = method.to_s
        if @inputs[key]
          @inputs[key].value
        else
          raise "no input #{key}"
        end
      end
    end

    def self.raw_inputs(inputs)
      inputs.instance_variable_get "@inputs"
    end
  end
end
