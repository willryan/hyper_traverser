module HyperTraverser
  class HyperInputs
    def initialize(inputs)
      @inputs = Hash[inputs.map do |k, v|
        [k, HyperInput.new(v)]
      end]
      @inputs.each do |k, v|
        receiver = self
        receiver.define_singleton_method(k) do |*args|
          v.value
        end
        receiver.define_singleton_method("#{k}=") do |*args|
          v.value = args[0]
        end
      end
    end

    def self.raw_inputs(inputs)
      inputs.instance_variable_get "@inputs"
    end
  end
end
