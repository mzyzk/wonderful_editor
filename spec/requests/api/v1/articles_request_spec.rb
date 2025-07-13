# spec/requests/api/v1/article_request_spec.rb
require "rails_helper"

RSpec.describe "Api::V1::Articles", type: :request do
  let(:user) { create(:user) }
  let(:headers) { user.create_new_auth_token }

  describe "GET /api/v1/articles" do
    context "when multiple articles exist" do
      before do
        create(:article, title: "Old Article", updated_at: 1.day.ago)
        create(:article, title: "New Article", updated_at: Time.current)
        get "/api/v1/articles"
      end

      it "returns articles ordered by updated_at descending" do
        expect(json.first["title"]).to eq("New Article")
      end
    end

    context "when a single article exists" do
      before do
        create(:article, title: "Single Test Article")
        get "/api/v1/articles"
      end

      it "includes required keys in the response" do
        expect(json.first.keys).to include("id", "title", "updated_at")
      end

      it "does not include unnecessary keys" do
        expect(json.first).not_to have_key("body")
      end
    end
  end

  describe "GET /api/v1/articles/:id" do
    let(:article) { create(:article) }

    it "returns the specific article" do
      get "/api/v1/articles/#{article.id}"
      expect(response).to have_http_status(:ok)
      json = JSON.parse(response.body)
      expect(json["id"]).to eq(article.id)
      expect(json["title"]).to eq(article.title)
      expect(json["user_name"]).to eq(article.user.name)
    end

    it "returns 404 if the article is not found" do
      get "/api/v1/articles/0"
      expect(response).to have_http_status(:not_found)
    end
  end

  describe "POST /api/v1/articles" do
    let(:valid_params) { { article: { title: "Hello", body: "World" } } }

    context "with valid parameters" do
      it "creates a new article" do
        post "/api/v1/articles", params: valid_params, headers: headers
        expect(response).to have_http_status(:created)

        json = JSON.parse(response.body)
        expect(json["title"]).to eq("Hello")
        expect(json["body"]).to eq("World")
      end
    end

    context "with invalid parameters" do
      it "returns an error when the title is blank" do
        post "/api/v1/articles", params: { article: { title: "" } }, headers: headers
        expect(response).to have_http_status(:unprocessable_entity)
      end
    end
  end

  describe "PATCH /api/v1/articles/:id" do
    let!(:article) { create(:article, user: user) }

    context "with valid parameters" do
      let(:update_params) do
        {
          article: {
            title: "Updated Title",
            body: "Updated Body",
          },
        }
      end

      it "updates the article" do
        patch "/api/v1/articles/#{article.id}", params: update_params, headers: headers
        expect(response).to have_http_status(:ok)
        json = JSON.parse(response.body)
        expect(json["title"]).to eq("Updated Title")
        expect(json["body"]).to eq("Updated Body")
      end
    end

    context "with invalid parameters" do
      let(:invalid_params) do
        {
          article: {
            title: "",
          },
        }
      end

      it "returns an error when the title is blank" do
        patch "/api/v1/articles/#{article.id}", params: invalid_params, headers: headers
        expect(response).to have_http_status(:unprocessable_entity)
      end
    end
  end

  describe "DELETE /api/v1/articles/:id" do
    let!(:article) { create(:article, user: user) }

    it "deletes the article" do
      expect {
        delete "/api/v1/articles/#{article.id}", headers: headers
      }.to change(Article, :count).by(-1)

      expect(response).to have_http_status(:no_content)
    end
  end
end
