require 'rails_helper'

RSpec.describe User, type: :model do
  let(:user) { FactoryGirl.build :user }

  describe "Test validation" do
    describe "#name" do
      context "when name is not present" do
        not_present_names = ["", "  ", nil]
        not_present_names.each do |invalid_name|
          before { user.name = invalid_name }
          it "should not valid" do
            expect(user).not_to be_valid
          end
        end
      end

      context "when name is too long" do
        before { user.name = "a"*51 }
        it "should not valid" do
          expect(user).not_to be_valid
        end
      end
    end

    describe "#email" do
      context "when email is not present" do
        not_present_emails = ["", "  ", nil]
        not_present_emails.each do |invalid_email|
          before { user.email = invalid_email }
          it "should not valid" do
            expect(user).not_to be_valid
          end
        end
      end

      context "when email is too long" do
        before { user.email = "a"*248 + "@example.com" }
        it "should not valid" do
          expect(user).not_to be_valid 
        end
      end

      context "when email is wrong format" do
        it "should not valid" do
          wrong_format_emails = %w[user@example,com user_at_foo.org user.name@example.
            foao@bar_baz.com foo@bar+baz.com]
          wrong_format_emails.each do |invalid_email|
            user.email = invalid_email
            expect(user).not_to be_valid
          end
        end
      end

      context "when email already taken" do
        before { FactoryGirl.create :user, email: "test@example.com" }
        it "should not valid" do
          user.email = "TEST@example.com"
          expect(user).not_to be_valid 
        end
      end
    end

    describe "#password"  do
      context "when password is not present" do
        not_present_passwords = ["", "  ", nil]
        not_present_passwords.each do |invalid_pass|
          before { user.password = user.password_confirmation = invalid_pass }
          it "should not valid" do
            expect(user).not_to be_valid
          end
        end
      end

      context "when password is too short" do
        before { user.password = user.password_confirmation = "a"*5 }
        it "should not valid" do
          expect(user).not_to be_valid
        end
      end

      context "when password and password_confirmation not match" do
        before do
          user.password = "foobar"
          user.password_confirmation = "foobaz"
        end
        it "should not valid" do
          expect(user).not_to be_valid
        end
      end
    end

    describe "#gender" do
      context "when gender not in list" do
        before { user.gender = "Not In List" }
        it "should not valid" do
          expect(user).not_to be_valid
        end
      end
    end

    describe "#All info is valid" do
      it "should valid" do
        email_list = ["USER@foo.COM", "THE_US-ER@foo.bar.org", "first.last@foo.jp"]
        gender_list = ["Male", "Female"]
        user.email = email_list.sample
        user.gender = gender_list.sample
        expect(user).to be_valid
      end
    end
  end

  describe "Check method" do
    describe "#email_downcase" do
      it "should word" do
        user.email = "DUc@ExamplE.com"
        user.save
        expect(user.email).to eq("duc@example.com")
      end
    end
  end
end
