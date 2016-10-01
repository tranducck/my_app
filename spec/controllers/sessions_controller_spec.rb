require 'rails_helper'

RSpec.describe SessionsController, type: :controller do
  before { @user = FactoryGirl.create :user }
  let(:login_params) {
    {
      email: "my@string.com",
      password: "password"
    }
  }

  describe "GET #new" do
    context "when already logged in" do
      it "should redirect_to current user" do
        session[:user_id] = @user.id
        get :new
        expect(response).to redirect_to @user
        expect(flash[:warning]).not_to be nil
      end
    end

    context "when not logged in" do
      it "should render new" do
        get :new
        expect(response).to render_template(:new)
      end
    end
  end

  describe "POST #create" do
    context "when already logged in" do
      it "should redirect_to current user" do
        session[:user_id] = @user.id
        post :create, params: { session: login_params }
        expect(response).to redirect_to @user
        expect(flash[:warning]).not_to be nil
      end
    end

    context "when not logged in" do
      context "and email not found" do
        before { login_params[:email] = "Not@found.com" }
        it "should render new" do
          post :create, params: { session: login_params }
          expect(response).to render_template(:new)
          expect(flash[:danger]).not_to be nil 
        end
      end

      context "and password not correct" do
        before { login_params[:password] = "NotCorrect" }
        it "should render new" do
          post :create, params: { session: login_params }
          expect(response).to render_template(:new)
          expect(flash[:danger]).not_to be nil 
        end
      end

      context "with correct email && password" do
        it "should success" do
          post :create, params: { session: login_params }
          expect(session[:user_id]).to eq @user.id
          expect(flash[:success]).not_to be nil
        end
      end
    end
  end

  describe "DELETE #destroy"do
    it "should success" do
      session[:user_id] = @user.id
      delete :destroy
      expect(session[:user_id]).to be nil
      expect(@current_user).to be nil
      expect(response).to redirect_to root_path
    end
  end
end
