require 'spec_helper'

describe "robots/edit" do
  before(:each) do
    @robot = assign(:robot, stub_model(Robot,
      :user_id => 1,
      :name => "",
      :code => "MyText"
    ))
  end

  it "renders the edit robot form" do
    render

    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "form", :action => robots_path(@robot), :method => "post" do
      assert_select "input#robot_user_id", :name => "robot[user_id]"
      assert_select "input#robot_name", :name => "robot[name]"
      assert_select "textarea#robot_code", :name => "robot[code]"
    end
  end
end
