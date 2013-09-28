FactoryGirl.define do
	factory :user do
		 name                  "Example User"
		 email                 "exam-pl@e.user.com"
		 password              "foobar"
		 password_confirmation "foobar"
	end
end