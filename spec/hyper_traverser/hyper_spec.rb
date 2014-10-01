require 'spec_helper'

describe HyperTraverser::Hyper do
  subject { described_class }

  describe ".start" do
    let (:url) { "www.coolbeans.org" }
    it "defers to take_action" do
      HyperTraverser::Hyper.expects(:take_action).with(url, "GET").returns :state
      expect(subject.start(url)).to eq(:state)
    end
  end

  describe ".take_action" do
    let(:uri) { mock('uri', hostname: "somewhere.com", port: "3000" )}
    let(:url) { "www.whatup.com" }
    let(:request) { mock('request') }
    let(:response) { mock('response', body: {a: "b"}.to_json) }
    let(:http) { mock('http') }
    before do
      URI.expects(:parse).with(url).returns(uri)
      request.stubs(:set_form_data)
      http.expects(:request).with(request).returns(response)
      HyperTraverser::HyperInterpreter.expects(:create).with("a" => "b").returns :state
      Net::HTTP.expects(:new).with("somewhere.com", "3000").returns(http)
    end

    describe "uses the input url and method to create and send a request" do
      it "works for GET requests" do
        Net::HTTP::Get.expects(:new).with(uri).returns(request)
        expect(subject.take_action(url, "GET")).to eq(:state)
      end
      it "works for POST requests" do
        Net::HTTP::Post.expects(:new).with(uri).returns(request)
        expect(subject.take_action(url, "POST", "{'c': 'd'}")).to eq(:state)
      end
      it "works for PUT requests" do
        Net::HTTP::Put.expects(:new).with(uri).returns(request)
        expect(subject.take_action(url, "PUT", "{'c': 'd'}")).to eq(:state)
      end
    end

    it "sets request body if specified" do
        Net::HTTP::Put.expects(:new).with(uri).returns(request)
        request.expects(:set_form_data).with("{'c': 'd'}")
        expect(subject.take_action(url, "PUT", "{'c': 'd'}")).to eq(:state)
    end
  end
end
