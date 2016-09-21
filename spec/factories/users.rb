FactoryGirl.define do
  factory :user do
    name "MyString"
    email "my@string.com"
    password "password"
    password_confirmation "password"
    gender "Male"
  end
end
