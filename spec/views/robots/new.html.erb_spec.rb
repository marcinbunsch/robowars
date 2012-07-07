require 'spec_helper'

describe "robots/new" do
  before(:each) do
    assign(:robot, stub_model(Robot,
      :user_id => 1,
      :name => "",
      :code => "MyText"
    ).as_new_record)
  end

  it "renders new robot form" do
    render

    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "form", :action => robots_path, :method => "post" do
      assert_select "input#robot_user_id", :name => "robot[user_id]"
      assert_select "input#robot_name", :name => "robot[name]"
      assert_select "textarea#robot_code", :name => "robot[code]"
    end
  end
end
