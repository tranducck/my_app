require "rails_helper"

RSpec.describe UsersController, type: :controller do
  describe "#create" do
    let(:user_params) {
      {
        name: "Duc",
        password: "foobar",
        gender: "Male",
        password_confirmation: "foobar",
        email: "test@example.com"
      }
    }

    context "when name is not present" do
      it "should fail" do
        user_params[:name] = ""
        expect{ post :create, user: user_params }.to change(User, :count).by (0)
        expect(response).to render_template(:new)
      end
    end

    context "when name is too long" do
      it "should fail" do
        user_params[:name] = "a"*51
        expect{ post :create, user: user_params }.to change(User, :count).by (0)
        expect(response).to render_template(:new)
      end
    end

    context "when email is not present" do
      it "should fail" do
        user_params[:email] = ""
        expect{ post :create, user: user_params }.to change(User, :count).by (0)
        expect(response).to render_template(:new)
      end
    end

    context "when email is too long" do
      it "should fail" do
        user_params[:email] = "a"*248 + "@example.com"
        expect{ post :create, user: user_params }.to change(User, :count).by (0)
        expect(response).to render_template(:new)
      end
    end

    context "when email is wrong format" do
      it "should fail" do
        user_params[:email] = "wrong@format"
        expect{ post :create, user: user_params }.to change(User, :count).by (0)
        expect(response).to render_template(:new)
      end
    end
    
    context "when email already taken" do
      before { FactoryGirl.create :user, email: "test@example.com" }
      it "should fail" do
        expect{ post :create, user: user_params }.to change(User, :count).by (0)
        expect(response).to render_template(:new)
      end
    end

    context "all valid info" do
      it "should sucess" do
        expect{ post :create, user: user_params }.to change(User, :count).by (1)
        expect(response).to redirect_to User.last
        expect(flash[:success]).not_to be nil
      end
    end
  end
end
