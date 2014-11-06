# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :follow do
    user { FactoryGirl.create(:user) }
    following { FactoryGirl.create(:user) }
  end
end
