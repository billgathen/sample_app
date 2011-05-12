require 'spec_helper'

describe User do
  before(:each) do
    @args = {
      :name => "Bill Gathen",
      :email => "bill.gathen@adtegrity.com",
      :password => "foobar",
      :password_confirmation => "foobar"
    }
  end

  it "creates a new instance with valid attributes" do
    User.create!(@args)
  end

  it "requires a name" do
    user = User.new
    user.should_not be_valid
    user.errors.full_messages.should include("Name can't be blank")
  end

  it "rejects a name that's too long" do
    max_length = 50
    user = User.new(@args.merge(:name => 'X' * (max_length + 1)))
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
      user = User.new(@args.merge(:email => addy))
      user.should be_valid
    end
  end

  it "rejects invalid email addresses" do
    %w[user@foo,com THE_USER_at_foo.bar.org first.last@foo.].each do |addy|
      user = User.new(@args.merge(:email => addy))
      user.should_not be_valid
      user.errors.full_messages.should include("Email is invalid")
    end
  end

  it "rejects duplicate email addresses" do
    User.create!(@args)
    dupe = User.new(@args)
    dupe.should_not be_valid
    dupe.errors.full_messages.should include("Email has already been taken")
  end

  describe "password validations" do
    it "requires a password" do
      User.new(@args.merge(:password => "", :password_confirmation => "")).should_not be_valid
    end

    it "requires a matching password confirmation" do
      User.new(@args.merge(:password_confirmation => "I don't match")).should_not be_valid
    end

    it "rejects short passwords" do
      User.new(@args.merge(:password => "short")).should_not be_valid
    end

    it "rejects long passwords" do
      max_length = 40
      too_long = "x" * (max_length + 1)
      User.new(@args.merge(:password => too_long, :password_confirmation => too_long)).should_not be_valid
    end
  end

  describe "password encryption" do
    before(:each) do
      @user = User.create!(@args)
    end

    it "has an encrypted password attribute" do
      @user.should respond_to(:encrypted_password)
    end

    it "sets the encrypted password on save" do
      @user.encrypted_password.should_not be_blank
    end

    describe "has_password? method" do
      it "returns true if password matches" do
        @user.has_password?(@args[:password]).should be_true
      end
      
      it "returns false if password doesn't match" do
        @user.has_password?("invalid").should be_false
      end
    end

    describe "authentication" do
      it "returns nil on email/pass mismatch" do
        wrong_password_user = User.authenticate(@args[:email], "wrongpass")
        wrong_password_user.should be_nil
      end

      it "returns nil for email without user" do
        nonexistent_user = User.authenticate("no_user@example.com", @args[:password])
        nonexistent_user.should be_nil
      end

      it "returns the user on email/pass match" do
        matching_user = User.authenticate(@args[:email], @args[:password])
        matching_user.should == @user
      end
    end

  end
end
