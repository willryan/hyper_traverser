require 'spec_helper'

describe HyperTraverser::HyperInputs do
  let :inputs do
    described_class.new(
      "name" => {"value" => nil, "type" => "text", "required" => true},
      "address" => {"value" => "123 nowhere", "type" => "text", "required" => false},
      "age" => {"value" => 47, "type" => "integer", "required" => false}
    )
  end

  describe "getting inputs" do
    it "allows you to read out the properties that it was created with" do
      expect(inputs.name).to be_nil
      expect(inputs.address).to eq "123 nowhere"
      expect(inputs.age).to eq 47
    end
  end

  describe "setting inputs" do
    it "allows you to prepare data to be sent to the server" do
      inputs.name = "the dude"
      inputs.age = 40

      expect(inputs.name).to eq "the dude"
      expect(inputs.age).to eq 40
    end
  end

  describe "missing input" do
    it "blows up when you try to access a field that doesn't exist" do
      expect { inputs.foo = :banana }.to raise_error NoMethodError
      expect { inputs.wat }.to raise_error NoMethodError
    end
  end
end
