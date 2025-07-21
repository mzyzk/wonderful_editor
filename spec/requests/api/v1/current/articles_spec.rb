# spec/requests/api/v1/current/articles_spec.rb
require "rails_helper"

RSpec.describe "Api::V1::Current::Articles", type: :request do
  describe "GET /api/v1/current/articles" do
    let(:user) { create(:user) }
    let!(:published_article) { create(:article, user: user, status: "published") }
    let!(:draft_article) { create(:article, user: user, status: "draft") }
    let!(:other_article) { create(:article, status: "published") }

    it "returns only current user's published articles" do
      get "/api/v1/current/articles", headers: user.create_new_auth_token
      expect(response).to have_http_status(:ok)
      json = JSON.parse(response.body)
      expect(json.length).to eq(1)
      expect(json.first["id"]).to eq(published_article.id)
    end
  end
end
