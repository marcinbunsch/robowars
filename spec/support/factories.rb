require "factory_girl"

FactoryGirl.define do

  factory :robot do
    name "Some robot"
    code "123"
    ready true
  end

end
