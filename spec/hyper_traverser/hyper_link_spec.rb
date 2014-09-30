require 'spec_helper'

describe HyperTraverser::HyperLink do
  describe "#resolve" do
    it "locates the resource at a url" do
      subject = described_class.new "www.google.com"
      HyperTraverser::Hyper.expects(:start).with("www.google.com").returns :new_resource
      expect(described_class.resolve(subject)).to eq(:new_resource)
    end
  end
end
