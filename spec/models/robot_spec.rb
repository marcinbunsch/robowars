require 'spec_helper'

describe Robot do

  describe "simple_draw" do

    it "selects 4 robots for the fight" do
      a = FactoryGirl.create :robot, :results_count => 1
      b = FactoryGirl.create :robot, :results_count => 1
      c = FactoryGirl.create :robot, :results_count => 1
      d = FactoryGirl.create :robot, :results_count => 4
      FactoryGirl.create :robot, :results_count => 4
      FactoryGirl.create :robot, :results_count => 4
      FactoryGirl.create :robot, :results_count => 4
      Robot.simple_draw(4).all.should == [a, b, c, d]
    end

  end

  describe "yoda_draw" do

    it "draws first half from first 1/4, second half from second 3/4" do
      a = FactoryGirl.create :robot, :results_count => 1
      b = FactoryGirl.create :robot, :results_count => 1
      c = FactoryGirl.create :robot, :results_count => 1
      d = FactoryGirl.create :robot, :results_count => 4
      e = FactoryGirl.create :robot, :results_count => 4
      f = FactoryGirl.create :robot, :results_count => 4
      g = FactoryGirl.create :robot, :results_count => 4
      h = FactoryGirl.create :robot, :results_count => 4
      results = Robot.yoda_draw(4)
      results.size.should == 4
      [a,b].should include(results[0])
      [a,b].should include(results[1])
      [c,d,e,f,g,h].should include(results[2])
      [c,d,e,f,g,h].should include(results[3])
    end

  end

end

