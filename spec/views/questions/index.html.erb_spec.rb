require 'spec_helper'

describe "questions/index" do
  let(:user_id) { 1 }
  let(:is_staff) { false }
  let(:user) do
    stub_model(User,
      :id => user_id,
      :staff => is_staff
    )
  end

  before(:each) do
    view.stub(:current_user => user)
    assign(:questions, [
      stub_model(Question,
        :user_id => user_id,
        :question => "Question",
        :answer => "MyText"
      ),
      stub_model(Question,
        :user_id => user_id + 1,
        :question => "Question 2",
        :answer => "MyText"
      )
    ])
  end

  it "renders a list of questions" do
    render
    assert_select "h2", :text => "Question".to_s, :count => 1
    assert_select "h2", :text => "Question 2".to_s, :count => 1
  end

  it "renders one option to edit and remove" do
    render
    assert_select "a", :text => "Edit".to_s, :count => 1
    assert_select "a", :text => "Remove".to_s, :count => 1
  end

  context "when is staff" do
    let(:is_staff) { true }

    it "renders many options to edit and remove" do
      render
      assert_select "a", :text => "Edit".to_s, :count => 2
      assert_select "a", :text => "Remove".to_s, :count => 2
    end

  end

end


