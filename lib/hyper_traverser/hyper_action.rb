module HyperTraverser
  class HyperAction
    attr_reader :inputs
    attr_reader :destination
    attr_reader :method

    def initialize(data)
      @inputs = HyperInputs.new data["input"]
      @destination = data["action"]
      @method = data["method"]
    end

    def submit(input_values)
      input_values.each do |k, v|
        inputs.send "#{k}=".to_sym, v
      end
      body = Hash[HyperInputs.raw_inputs(@inputs).map do |k, v|
        [k, v.value]
      end].to_json
      Hyper.take_action(@destination, @method, body)
    end
  end
end
