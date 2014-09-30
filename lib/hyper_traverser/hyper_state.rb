module HyperTraverser
  class HyperState

    def initialize(data, links, actions)
      if data["collection"]
        @collection = data.delete "collection"
      end
      @data = data
      @links = links
      @actions = actions
    end

    def [](index)
      if @collection
        @collection[index]
      else
        raise "state is not a collection"
      end
    end

    # TODO define methods
    def method_missing(method, *params)
      key = method.to_s
      if @actions[key]
        @actions[key]
      elsif @links[key]
        @links[key].resolve
      elsif @data[key]
        @data[key]
      else
        raise "#{method} not found"
      end
    end

    def self.actions(state)
      state.instance_variable_get "@actions"
    end

    def self.links(state)
      state.instance_variable_get "@links"
    end

    def self.data(state)
      state.instance_variable_get "@data"
    end

    def self.collection(state)
      state.instance_variable_get "@collection"
    end
  end
end
