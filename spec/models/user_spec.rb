require 'spec_helper'

describe User do
  it "creates a new instance with valid attributes" do
    User.create!(:name => "Bill Gathen", :email => "bill.gathen@adtegrity.com")
  end

  it "requires a name" do
    user = User.new
    user.should_not be_valid
    user.errors.full_messages.should include("Name can't be blank")
  end

  it "should reject a name that's too long" do
    max_length = 50
    user = User.new(:name => 'X' * (max_length + 1), :email => "a_valid_email@example.com")
    user.should_not be_valid
    user.errors.full_messages.should include("Name is too long (maximum is #{max_length} characters)")
  end

  it "requires an email address" do
    user = User.new
    user.should_not be_valid
    user.errors.full_messages.should include("Email can't be blank")
  end

  it "requires a valid email address" do
    %w[user@foo.com THE_USER@foo.bar.org first.last@foo.jp].each do |addy|
      user = User.new(:name => "my name", :email => addy)
      user.should be_valid
    end
  end

  it "rejects invalid email addresses" do
    %w[user@foo,com THE_USER_at_foo.bar.org first.last@foo.].each do |addy|
      user = User.new(:name => "my name", :email => addy)
      user.should_not be_valid
      user.errors.full_messages.should include("Email is invalid")
    end
  end

  it "rejects duplicate email addresses" do
    name = "name"
    email = "me@example.com"
    User.create!(:name => name, :email => email)
    dupe = User.new(:name => name, :email => email.upcase)
    dupe.should_not be_valid
    dupe.errors.full_messages.should include("Email has already been taken")
  end
end
