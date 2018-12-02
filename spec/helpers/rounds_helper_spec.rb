require 'rails_helper'

# Specs in this file have access to a helper object that includes
# the RoundsHelper. For example:
#
# describe RoundsHelper do
#   describe "string concat" do
#     it "concats two strings with spaces" do
#       expect(helper.concat_strings("this","that")).to eq("this that")
#     end
#   end
# end
RSpec.describe RoundsHelper, type: :helper do
  it "should return arrow-up when the handicap has gone up" do
    expect(helper.handicap_movement_since_last_round(5.5, 5.4)).to include('arrow-up')
  end

  it "should return arrow-down when the handicap has gone down" do
    expect(helper.handicap_movement_since_last_round(5.5, 5.6)).to include('arrow-down')
  end

  it "should return arrow-right when the handicap has not changed" do
    expect(helper.handicap_movement_since_last_round(5.5, 5.5)).to include('arrow-right')
  end

  it "should return placeholder when the handicap is nil" do
    expect(helper.handicap_movement_since_last_round(nil, 5.4)).to include('placeholder')
  end

  it "should return placeholder when the previous handicap is nil" do
    expect(helper.handicap_movement_since_last_round(5.5, nil)).to include('placeholder')
  end
end
