require 'spec_helper'

describe HyperTraverser::HyperAction do
  let (:subject) { 
    described_class.new({ 
      "input" => { 
        "username" => {
          "type" => "text",
          "required" => true,
          "value" => "jim"
        },
        "email" => {
          "type" => "text",
          "required" => true,
          "value" => "foo@bar.com"
        },
      },
      "action" => "/some/route",
      "method" => "PUT"
    })
  }

  describe "#inputs" do
    it "returns the inputs created from data" do
      expect(subject.inputs.username).to eq("jim")
      expect(subject.inputs.email).to eq("foo@bar.com")
    end
  end
  
  describe "#submit" do
    it "sends a request with the right method and destination, and uses existing values with overrides from input" do
      HyperTraverser::Hyper.expects(:take_action).with("/some/route", "PUT", { username: "bob", email: "foo@bar.com" }.to_json).returns :new_state
      res = subject.submit username: "bob"
      expect(res).to eq(:new_state)
    end
  end
end
