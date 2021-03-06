require 'spec_helper'

describe "Users" do

  describe "signup" do

    describe "failure" do

      it "doesn't make a new user" do
        lambda do
          visit signup_path
          fill_in "Name", :with => ""
          fill_in "Email", :with => ""
          fill_in "Password", :with => ""
          fill_in "Password Confirmation", :with => ""
          click_button
          response.should have_selector("div#error_explanation")
        end.should_not change(User, :count)
      end

    end

    describe "success" do

      it "makes a new user" do
        lambda do
          visit signup_path
          fill_in "Name", :with => "Bill"
          fill_in "Email", :with => "bill.gathen@adtegrity.com"
          fill_in "Password", :with => "foobar"
          fill_in "Password Confirmation", :with => "foobar"
          click_button
          response.should have_selector("div.flash.success", :content => "Welcome")
        end.should change(User, :count).by(1)
      end

    end

  end

end
