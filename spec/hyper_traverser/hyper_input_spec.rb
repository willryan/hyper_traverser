require 'spec_helper'

describe HyperTraverser::HyperInput do
  let (:subject) { 
    described_class.new({
      "value" => "5",
      "type" => "number",
      "required" => true
    })
  }

  describe "#value" do
    it "contains the r/w value of the input" do
      expect(subject.value).to eq("5")
      subject.value = "11"
      expect(subject.value).to eq("11")
    end
  end

  describe "#required" do
    it "contains a r/o flag indicating if input is required" do
      expect(subject.required).to be true
      expect(subject.respond_to? :required=).to be false
    end
  end

  describe "#type" do
    it "is a r/o flag indicating the type of the input" do
      expect(subject.type).to eq("number")
      expect(subject.respond_to? :type=).to be false
    end
  end
end
