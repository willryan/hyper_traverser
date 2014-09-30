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
          "input" => ""
        }
      }
    end
  end
end
