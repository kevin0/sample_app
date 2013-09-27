require 'spec_helper'

describe User do
	before {
		@user = User.new(
			name: "Example User", 
			email: "user@example.com", 
			password: "foobar", 
			password_confirmation: "foobar"
		)
	}
	subject {@user}

	it {should respond_to(:name)}
	it {should respond_to(:email)}
	it {should respond_to(:password_digest)}
	it {should respond_to(:password)}
	it {should respond_to(:password_confirmation)}
	it {should respond_to(:authenticate)}
	
	it {should be_valid}

	describe "when name is not present" do
		before {@user.name = " "}
		it {should_not be_valid}
	end
	describe "when name is too long" do
		before {@user.name = "a"*51}
		it {should_not be_valid}
	end

	describe "when password is not present" do
		before {@user.password = " ", @user.password_confirmation = " "}
		it {should_not be_valid}
	end
	describe "when passwords do not match" do
		before {@user.password_confirmation = @user.password + "mismatch"}
		it {should_not be_valid}
	end
	describe "password too short" do
		before {@user.password = @user.password_confirmation = "a"*5}
		it {should be_invalid}
	end

	describe "authenticate method" do
		before {@user.save}
		let(:found_user) {User.find_by(email: @user.email)}
		describe "with valid password" do
			it {should eq found_user.authenticate(@user.password)}
		end
		describe "with invalid password" do
			let(:user_invalid) {found_user.authenticate(" ")}
			it {should_not eq user_invalid}
			specify {expect(user_invalid).to be_false}
		end
	end

	describe "email downcasing" do
		let(:mixed_case_email) {"Foo@BaR.COM"}
		it "should be saved in lower-case" do
			@user.email = mixed_case_email
			@user.save
			expect(@user.reload.email).to eq mixed_case_email.downcase
		end
	end

	describe "when email is not present" do
		before {@user.email = " "}
		it {should_not be_valid}
	end
	describe "when email is too long" do
		before {@user.email = "a"*51}
		it {should_not be_valid}
	end
	describe "when email format is invalid" do
		it "should be invalid" do
			addresses = [
				"user@foo,com",
				"user_at_foo.org",
				"example.user@foo.",
				"foo@bar_baz.com",
				"foo@bar+baz.com",
				"foo@bar..com"
			]
			addresses.each do |invalid_address|
				@user.email = invalid_address
				expect(@user).not_to be_valid
			end
		end
	end
	describe "when email format is valid" do
		it "should be valid" do
			addresses = [
				"user@foo.COM",
				"a_us-er@f.b.org",
				"fisrt.last@foo.jp",
				"a+b@c.com"
			]
			addresses.each do |valid_address|
				@user.email = valid_address
				expect(@user).to be_valid
			end
		end
	end
	describe "when email address is already taken" do
		before do
			user_with_same_email = @user.dup
			user_with_same_email.email = @user.email.upcase
			user_with_same_email.save
		end
		it {should_not be_valid}
	end
end
