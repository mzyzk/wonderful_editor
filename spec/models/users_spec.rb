# spec/models/user_spec.rb
require "rails_helper"

RSpec.describe User, type: :model do
  context "when all required fields are present" do
    let(:user) { build(:user) }

    it "is valid for user registration" do
      expect(user).to be_valid
    end
  end

  context "when only name is provided" do
    let(:user) { build(:user, email: nil, password: nil) }

    it "returns an error" do
      expect(user).not_to be_valid
    end
  end

  context "when email is missing" do
    let(:user) { build(:user, email: nil) }

    it "returns an error" do
      expect(user).not_to be_valid
    end
  end

  context "when password is missing" do
    let(:user) { build(:user, password: nil) }

    it "returns an error" do
      expect(user).not_to be_valid
    end
  end
end
