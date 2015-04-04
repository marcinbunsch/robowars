require 'spec_helper'

describe "questions/_form" do
  let(:user_id) { 1 }
  let(:is_staff) { false }
  let(:user) do
    stub_model(User,
      :id => user_id,
      :staff => is_staff
    )
  end
  let(:question) do
    stub_model(Question,
      :user_id => user_id,
      :question => "Question",
      :answer => "MyText"
    )
  end

  before(:each) do
    view.stub(:current_user => user)
    assign(:question, question)
  end

  context "regular user" do

    it "renders question input" do
      render
      assert_select "label", for: "question_question", count: 1
      assert_select "input#question_question", count: 1
    end

    it "does not render answer input" do
      render
      rendered.should_not match('question_answer')
    end

  end

  context "staff user" do
    let(:is_staff) { true }

    it "renders answer input" do
      render
      rendered.should match('question_answer')

      assert_select "textarea#question_answer", count: 1
    end

  end

end

