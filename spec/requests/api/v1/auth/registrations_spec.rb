require "rails_helper"

RSpec.describe "User Registration API", type: :request do
  describe "POST /api/v1/auth" do
    let(:valid_params) do
      {
        email: "test@example.com",
        password: "password",
        password_confirmation: "password",
      }
    end

    context "when the request is valid" do
      it "creates a new user and returns status 200" do
        post "/api/v1/auth", params: valid_params

        expect(response).to have_http_status(:ok)
        expect(JSON.parse(response.body)["data"]["email"]).to eq(valid_params[:email])
        expect(response.headers).to include("access-token", "client", "uid")
      end
    end

    context "when the request is invalid" do
      it "returns a 422 with error messages" do
        invalid_params = valid_params.merge(password_confirmation: "wrong")

        post "/api/v1/auth", params: invalid_params
        expect(response).to have_http_status(:unprocessable_entity)
        expect(JSON.parse(response.body)).to have_key("errors")
      end
    end
    context "when email is already token" do
      before { User.create!(email: valid_params[:email], password: "password", password_confirmation: "password") }

      it "returns 422 with error" do
        post "/api/v1/auth", params: valid_params

        expect(response).to have_http_status(:unprocessable_entity)
        expect(JSON.parse(response.body)).to have_key("errors")
      end
    end

    context "when email is blank" do
      it "returns 422 with error" do
        post "/api/v1/auth", params: valid_params.merge(email: "")

        expect(response).to have_http_status(:unprocessable_entity)
        expect(JSON.parse(response.body)).to have_key("errors")
      end
    end

    context "when password is too short" do
      it "returns 422 with error" do
        post "/api/v1/auth", params: valid_params.merge(password: "123", password_confirmation: "123")

        expect(response).to have_http_status(:unprocessable_entity)
        expect(JSON.parse(response.body)).to have_key("errors")
      end
    end

    context "when password confirmation does not match" do
      it "returns 422 with error" do
        post "/api/v1/auth", params: valid_params.merge(password_confirmation: "wrong")

        expect(response).to have_http_status(:unprocessable_entity)
        expect(JSON.parse(response.body)).to have_key("errors")
      end
    end

    context "when password confirmation is blank" do
      it "returns 422 with error" do
        post "/api/v1/auth", params: valid_params.merge(password_confirmation: "")

        expect(response).to have_http_status(:unprocessable_entity)
        expect(JSON.parse(response.body)).to have_key("errors")
      end
    end
  end
end
