module HyperTraverser
  class HyperInterpreter
    class << self
      def create(json)
        actions = {}
        links = {}
        data = {}
        json.each do |k, v|
          if v.is_a? Hash
            if v.keys.include? "action"
              actions[k] = HyperAction.new v
            elsif v.keys == ['href']
              links[k] = HyperLink.new v['href']
            else
              data[k] = self.create v
            end
          elsif v.is_a? Array
            data[k] = v.map do |val| self.create(val) end
          else
            data[k] = v
          end
        end
        HyperState.new(data, links, actions)
      end
    end
  end
end
