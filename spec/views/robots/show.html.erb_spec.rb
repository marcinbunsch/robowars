require 'spec_helper'

describe "robots/show" do
  before(:each) do
    @robot = assign(:robot, stub_model(Robot,
      :user_id => 1,
      :name => "",
      :code => "MyText"
    ))
  end

  it "renders attributes in <p>" do
    render
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    rendered.should match(/1/)
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    rendered.should match(//)
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    rendered.should match(/MyText/)
  end
end
