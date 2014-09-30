require_relative 'hyper'

module HyperTraverser
  class HyperLink
    def initialize(url)
      @url = url
    end

    def resolve
      Hyper.start(@url)
    end
  end
end
