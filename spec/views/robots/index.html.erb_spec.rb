require 'spec_helper'

describe "robots/index" do
  before(:each) do
    assign(:robots, [
      stub_model(Robot,
        :user_id => 1,
        :name => "",
        :code => "MyText"
      ),
      stub_model(Robot,
        :user_id => 1,
        :name => "",
        :code => "MyText"
      )
    ])
  end

  it "renders a list of robots" do
    render
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "tr>td", :text => 1.to_s, :count => 2
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "tr>td", :text => "".to_s, :count => 2
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "tr>td", :text => "MyText".to_s, :count => 2
  end
end
