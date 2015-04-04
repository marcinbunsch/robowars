require 'spec_helper'

describe QuestionsController do

  let(:user) do
    mock_model(User, { :id => 10, :staff? => false })
  end
  let(:another_user) do
    mock_model(User, { :id => 30, :staff? => false })
  end
  let(:staff) do
    mock_model(User, { :id => 20, :staff? => true })
  end
  let(:current_user) { user }
  let(:last_question) { Question.last }

  before do
    controller.stub(:authenticate_user)
    controller.stub(:current_user => current_user)
  end

  describe "#create" do
    let(:contents) { "Can haz?" }

    def create_question(params = {})
      post :create, :question => {
        :question => contents
      }.merge(params)
    end

    context "regular user" do
      it "can create question" do
        expect do
          create_question
        end.to change(Question, :count).by(1)
        last_question.question.should == contents
      end

      it "cannot create answer" do
        create_question({ :answer => 'Can!' })
        last_question.answer.should be_nil
      end

      it "sets the right user_id" do
        create_question
        last_question.user_id.should == user.id
      end

      it "redirects to index" do
        create_question
        response.should redirect_to(questions_path)
      end
    end

  end

  describe "#update" do

    let(:question) do
      Question.create({
        :question => 'Can?',
        :user_id => user.id
      })
    end

    def update_question(q, params = {})
      put :update, :id => q.id, :question => params
      q.reload
    end

    context "regular user" do
      it "can update question" do
        update_question question, :question => 'Haz?'
        question.question.should == 'Haz?'
      end
      it "cannot update answer" do
        update_question question, :answer => 'Yes'
        question.answer.should be_nil
      end
      it "redirects to index" do
        update_question question, :question => 'Haz?'
        response.should redirect_to(questions_path)
      end
    end

    context "another user" do
      let(:current_user) { another_user }
      it "cannot update first users's question" do
        expect do
          update_question question, :question => 'Haz?'
        end.to raise_error(ActiveRecord::RecordNotFound)
      end
    end

    context "staff user" do
      let(:current_user) { staff }
      it "can update another's question" do
        update_question question, :question => 'Haz?'
        question.question.should == 'Haz?'
      end
      it "can update answer" do
        update_question question, :answer => 'Yes'
        question.answer.should == 'Yes'
      end
    end

  end

  describe "#destroy" do

    let(:question) do
      Question.create({
        :question => 'Can?',
        :user_id => user.id
      })
    end

    before do
      question
    end

    context "regular user" do
      it "can remove question" do
        expect do
          put :destroy, :id => question.id
        end.to change(Question, :count).by(-1)
      end
    end

    context "another user" do
      let(:current_user) { another_user }
      it "cannot remove first users's question" do
        expect do
          put :destroy, :id => question.id
        end.to raise_error(ActiveRecord::RecordNotFound)
      end
    end

    context "staff user" do
      let(:current_user) { staff }
      it "can remove another's question" do
        expect do
          put :destroy, :id => question.id
        end.to change(Question, :count).by(-1)
      end
    end

  end
end
