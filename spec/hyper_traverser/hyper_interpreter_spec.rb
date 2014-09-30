require 'spec_helper'

describe HyperTraverser::HyperInterpreter do
  describe ".create" do
    it "creates an appropriate HyperState object out of the provided data" do
      raw_data = {
        "barney" => "stinson",
        "blarney" => "stone",
        "cool_stuff" => [
          { "thing" => "beans" },
          { "thing" => "windows 10" },
          { "href" => "http://microsoft.com" }
        ],
        "get_more_cool_stuff" => {
          "href" => "http://google.com/search?q=cool+stuff"
        },
        "doit" => {
          "action" => "http://duckduckgo.com",
          "method" => "PUT",
          "input" => {
            "search" => {
              "type" => "text",
              "required" => true,
              "value" => ""
            },
            "result_limit" => {
              "type" => "integer",
              "required" => "false",
              "value" => 100
            }
          }
        }
      }

      HyperTraverser::Hyper.expects(:take_action).with("http://microsoft.com", "GET").returns(described_class.create({ "bing" => "bang" }))
      HyperTraverser::Hyper.expects(:take_action).with("http://google.com/search?q=cool+stuff", "GET").returns(described_class.create({ "docs" => "drive" }))
      HyperTraverser::Hyper.expects(:take_action).with("http://duckduckgo.com", "PUT", { search: "goose", result_limit: 40}.to_json).returns(described_class.create({ "quack" => "quack" }))

      hyper_obj = described_class.create raw_data
      expect(hyper_obj.barney).to eq("stinson")
      expect(hyper_obj.blarney).to eq("stone")
      expect(hyper_obj.cool_stuff[0].thing).to eq("beans")
      cool_stuff = hyper_obj.cool_stuff
      expect(cool_stuff[1].thing).to eq("windows 10")
      expect(cool_stuff[2].bing).to eq("bang")
      expect(hyper_obj.get_more_cool_stuff.docs).to eq("drive")
      doit = hyper_obj.doit
      expect(doit.inputs.search).to eq("")
      expect(doit.inputs.result_limit).to eq(100)
      doit.inputs.search = "goose"
      doit.inputs
      response = doit.submit result_limit: 40
      expect(response.quack).to eq("quack")
    end

    it "creates collections" do
      raw_data = {
        "barney" => "stinson",
        "collection" => [
          { "href" => "www.ruby.com" },
          { "href" => "www.javascript.com" },
        ]
      }

      HyperTraverser::Hyper.expects(:take_action).with("www.ruby.com", "GET").returns(described_class.create({ "proc" => "block" }))
      HyperTraverser::Hyper.expects(:take_action).with("www.javascript.com", "GET").returns(described_class.create({ "good" => "parts" }))

      hyper_obj = described_class.create raw_data
      expect(hyper_obj.barney).to eq("stinson")
      expect(hyper_obj[0].proc).to eq("block")
      expect(hyper_obj[1].good).to eq("parts")
      
    end
  end
end
