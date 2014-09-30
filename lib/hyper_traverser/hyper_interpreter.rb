module HyperTraverser
  class HyperInterpreter
    class << self
      def create(json)
        if json.keys == ['href']
          return HyperLink.new json['href']
        end
        actions = {}
        data = {}
        json.each do |k, v|
          if v.is_a? Hash
            if v.keys.include? "action"
              actions[k] = HyperAction.new v
            else
              data[k] = self.create v
            end
          elsif v.is_a? Array
            if k == "collection"
              data[k] = v.map do |value| self.create value end
            else
              data[k] = self.create({"collection" => v})
            end
          else
            data[k] = v
          end
        end
        HyperState.new(data, actions)
      end
    end
  end
end
