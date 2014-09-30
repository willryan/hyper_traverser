module HyperTraverser
  class HyperState

    def initialize(data, actions)
      if data["collection"]
        @collection = data.delete "collection"
      end
      @data = data
      @data.each do |k, v|
        receiver = self
        receiver.define_singleton_method(k) do |*args|
          HyperState::resolve_object v
        end
      end
      @actions = actions
      @actions.each do |k, v|
        receiver = self
        receiver.define_singleton_method(k) do |*args|
          v
        end
      end
    end

    def [](index)
      if @collection
        HyperState.resolve_object(@collection[index])
      else
        raise HyperTraverser::HyperException, "state is not a collection"
      end
    end

    def self.actions(state)
      state.instance_variable_get "@actions"
    end

    def self.data(state)
      state.instance_variable_get "@data"
    end

    def self.collection(state)
      state.instance_variable_get "@collection"
    end

    def self.resolve_object(obj)
      if obj.class.respond_to? :resolve 
        obj.class.resolve(obj)
      else
        obj
      end
    end
  end
end
