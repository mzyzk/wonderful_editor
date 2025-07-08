require "rails_helper"

RSpec.describe "User Login API", type: :request do
  describe "POST /api/v1/auth/sign_in" do
    let!(:user) { User.create!(email: "test@example.com", password: "password", password_confirmation: "password") }

    context "with valid credentials" do
      it "returns 200 and authentication headers" do
        post "/api/v1/auth/sign_in", params: { email: user.email, password: "password" }

        expect(response).to have_http_status(:ok)
        expect(JSON.parse(response.body)["data"]["email"]).to eq(user.email)
        expect(response.headers).to include("access-token", "client", "uid")
      end
    end

    context "with invalid credentials" do
      it "returns 401 unauthorized" do
        post "/api/v1/auth/sign_in", params: { email: user.email, password: "wrongpassword" }

        expect(response).to have_http_status(:unauthorized)
        expect(JSON.parse(response.body)).to have_key("errors")
      end
    end
  end
end
