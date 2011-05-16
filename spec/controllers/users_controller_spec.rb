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

  describe "POST 'create'" do

    describe "failure" do

      before(:each) do
        @attr = { :name => "", :email => "", :password => "", :password_confirmation => ""}
      end

      it "doesn't create a user" do
        lambda do
          post :create, :user => @attr
        end.should_not change(User, :count)
      end

      it "has the right title" do
        post :create, :user => @attr
        response.should have_selector(:title, :content => "Sign up")
      end

      it "re-renders the new page" do
        post :create, :user => @attr
        response.should render_template('new')
      end

    end

    describe "success" do

      before(:each) do
        @attr = Factory.attributes_for(:user)
      end

      it "creates a user" do
        lambda do
          post :create, :user => @attr
        end.should change(User, :count).by(1)
      end

      it "redirects to the user show page" do
        post :create, :user => @attr
        response.should redirect_to(user_path(assigns(:user)))
      end

      it "displays a welcome message" do
        post :create, :user => @attr
        flash[:success].should =~ /welcome to the sample app/i
      end

    end

  end

end
