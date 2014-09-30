require 'spec_helper'

describe HyperTraverser::HyperState do
  describe "data" do
    it "returns data items" do
      state = described_class.new({
        "something" => true,
        "okay" => "quite",
        "snakes_on_a_plane" => "was awful"
      }, {

      })

      expect(state.something).to be true
      expect(state.okay).to eq "quite"
      expect(state.snakes_on_a_plane).to eq "was awful"
    end

    it "resolves data items before returning them" do
      banana_state = HyperTraverser::HyperState.new({"a" => "bananas"}, {})
      HyperTraverser::Hyper.expects(:start).with("http://gorillaz.com").returns banana_state
      state = described_class.new({
        "treasure" => HyperTraverser::HyperLink.new("http://gorillaz.com")
      }, {

      })

      expect(state.treasure.a).to eq "bananas"
    end
  end

  describe "actions" do
    it "returns actions by name" do
      push_the_button = HyperTraverser::HyperAction.new(
        "destination" => "clown city",
        "method" => "PUT or GET or whatever",
        "input" => {"name" => {"type" => "text", "required" => true, "value" => "wut"}}
      )

      state = described_class.new({}, {"pushit" => push_the_button})
      expect(state.pushit).to eq push_the_button
    end
  end

  describe "collections" do
    it "returns collection items" do
      state = described_class.new({
        "collection" => [
          described_class.new({"meh" => "nihilist"}, {}),
          described_class.new({"aoeu" => "idhtns"}, {})
        ]
      }, {})
      expect(state[0].meh).to eq "nihilist"
      expect(state[1].aoeu).to eq "idhtns"
    end

    it "resolves collection items before returning them" do
      kitten_state = HyperTraverser::HyperState.new({"name" => "fuzzy"}, {})
      puppy_state = HyperTraverser::HyperState.new({"name" => "barky"}, {})
      HyperTraverser::Hyper.expects(:start).with("http://placekitten.com").returns kitten_state
      HyperTraverser::Hyper.expects(:start).with("http://placepuppy.com").returns puppy_state

      state = described_class.new({
        "collection" => [
          HyperTraverser::HyperLink.new("http://placekitten.com"),
          HyperTraverser::HyperLink.new("http://placepuppy.com"),
          described_class.new({"wut" => "idk"}, {})
        ]
      }, {})

      expect(state[0].name).to eq "fuzzy"
      expect(state[1].name).to eq "barky"
      expect(state[2].wut).to eq "idk"
    end
  end

  describe "data not found" do
    it "throws an exception when looking for a missing key" do
      state = described_class.new( {},{} ) #bzzzzz
      expect { state.nacho_cheese }.to raise_error NoMethodError
    end
  end

  describe "exploration" do
    describe ".actions" do
      it "returns the actions hash" do
        first_thing = HyperTraverser::HyperAction.new("input" => {})
        one_more_thing = HyperTraverser::HyperAction.new("input" => {})

        state = described_class.new({
          "extraneous" => "details",
        }, {
          "first_thing" => first_thing,
          "one_more_thing" => one_more_thing
        })

        expect(described_class.actions(state)).to eq(
          "first_thing" => first_thing,
          "one_more_thing" => one_more_thing
        )
      end
    end
    describe ".data" do
      it "returns values that were passed in" do
        state = described_class.new({
          "okay" => "i suppose"
        }, {
          "unused" => HyperTraverser::HyperAction.new("input" => {})
        })

        expect(described_class.data(state)).to eq(
          "okay" => "i suppose"
        )
      end
    end
    describe ".collection" do
      it "returns the array of items" do
        first_link = HyperTraverser::HyperLink.new "http://littlecaesars.com"
        weakest_link = HyperTraverser::HyperLink.new "http://nbc.com"
        state = described_class.new({
          "collection" => [
            first_link,
            weakest_link
          ],
          "id" => 4
        }, {
          "unused" => HyperTraverser::HyperAction.new("input" => {})
        })

        expect(described_class.collection(state)).to eq [
          first_link,
          weakest_link
        ]
      end
    end
  end
end
