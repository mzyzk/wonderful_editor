require "rails_helper"
RSpec.describe "Api::V1::Articles", type: :request do
  describe "GET /api/v1/articles" do
    context "記事が複数あるとき" do
      before do
        create(:article, title: "古い記事", updated_at: 1.day.ago)
        create(:article, title: "新しい記事", updated_at: Time.current)
        get "/api/v1/articles"
      end

      it "更新順に整列されていること" do
        expect(json.first["title"]).to eq("新しい記事")
      end
    end

    context "記事が1件あるとき" do
      before do
        create(:article, title: "単体テスト用")
        get "/api/v1/articles"
      end

      it "必要なキーが含まれていること" do
        expect(json.first.keys).to include("id", "title", "updated_at")
      end

      it "不要なキーが含まれていないこと" do
        expect(json.first).not_to have_key("body")
      end
    end
  end

  describe "GET /api/v1/articles/:id" do
    let(:article) { create(:article) }

    it "returns a specific article" do
      get "/api/v1/articles/#{article.id}"
      expect(response).to have_http_status(:ok)
      json = JSON.parse(response.body)
      expect(json["id"]).to eq(article.id)
      expect(json["title"]).to eq(article.title)
      expect(json["user_name"]).to eq(article.user.name)
    end
    it "returns 404 if article is not found" do
      get "/api/v1/articles/0"
      expect(response).to have_http_status(:not_found)
    end
  end

  describe "POST /api/v1/articles" do
    let!(:user) { create(:user) }
    let(:valid_params) { { article: { title: "Hello", body: "World" } } }

    it "creates a new article" do
      post "/api/v1/articles", params: valid_params
      expect(response).to have_http_status(:created)

      json = JSON.parse(response.body)
      expect(json["title"]).to eq("Hello")
      expect(json["body"]).to eq("World")
    end
    describe "POST /api/v1/articles" do
      let(:user) { create(:user) }
      before { user }
      let(:valid_params) { { article: { title: "Hello", body: "World" } } }

      it "creates a new article" do
        post "/api/v1/articles", params: valid_params
        expect(response).to have_http_status(:created)
        json = JSON.parse(response.body)
        expect(json["title"]).to eq("Hello")
        expect(json["body"]).to eq("World")
      end

      it "returns error when params are invalid" do
        post "/api/v1/articles", params: { article: { title: "" } }
        expect(response).to have_http_status(:unprocessable_entity)
      end
    end
  end

  describe "PATCH /api/v1/articles/:id" do
    let(:user) { create(:user) }
    let!(:article) { create(:article, user: user) }

    before { user }

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
        patch "/api/v1/articles/#{article.id}", params: update_params
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

      it "returns error when title is blank" do
        patch "/api/v1/articles/#{article.id}", params: invalid_params
        expect(response).to have_http_status(:unprocessable_entity)
      end
    end
  end

  describe "DELETE /api/v1/articles/:id" do
    let(:user) { create(:user) }
    let!(:article) { create(:article, user: user) }

    it "deletes the article" do
      expect {
        delete "/api/v1/articles/#{article.id}"
      }.to change(Article, :count).by(-1)

      expect(response).to have_http_status(:no_content)
    end
  end
end
