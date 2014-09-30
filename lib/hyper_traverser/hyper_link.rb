module HyperTraverser
  class HyperLink
    attr_reader :url
    def initialize(url)
      @url = url
    end

    def self.resolve(hyper_obj)
      Hyper.start(hyper_obj.url)
    end
  end
end
