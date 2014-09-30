module HyperTraverser
  class HyperInput
    attr_accessor :value
    attr_reader :required
    attr_reader :type

    def initialize(data)
      @value = data["value"]
      @type = data["type"]
      @required = data["required"]
    end
  end
end
