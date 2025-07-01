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
end
