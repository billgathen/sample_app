require 'spec_helper'

describe UsersController do
  render_views

  describe "GET 'new'" do
    it "should be successful" do
      get 'new'
      response.should be_success
    end

    it "should have the right title" do
      get 'new'
      response.should have_selector("title", :content => "Sign up")
    end
  end

  describe "GET 'show'" do

    before(:each) do
      @user = Factory(:user)
      get :show, :id => @user
    end

    it "succeeds" do
      response.should be_success
    end

    it "finds right user" do
      assigns(:user).should == @user
    end

    it "displays the right title" do
      response.should have_selector("title", :content => @user.name)
    end

    it "includes the user's name" do
      response.should have_selector("h1", :content => @user.name)
    end

    it "has a profile image" do
      response.should have_selector("h1>img", :class => "gravatar")
    end

  end

end
