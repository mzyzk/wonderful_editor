# spec/requests/api/v1/articles_request_spec.rb
require "rails_helper"

RSpec.describe "Api::V1::Articles", type: :request do
  # omitted

  describe "POST /articles" do
    subject { post(api_v1_articles_path, params: params) }

    let(:params) { { article: attributes_for(:article) } }
    let(:current_user) { create(:user) }

    # stub
    before { allow_any_instance_of(Api::V1::BaseApiController).to receive(:current_user).and_return(current_user) }

    it "creates a new article record" do
      expect { subject }.to change { Article.where(user_id: current_user.id).count }.by(1)
      res = JSON.parse(response.body)
      expect(res["title"]).to eq params[:article][:title]
      expect(res["body"]).to eq params[:article][:body]
      expect(response).to have_http_status(:ok)
    end
  end

  describe "PATCH /api/v1/articles/:id" do
    subject { patch(api_v1_article_path(article.id), params: params) }

    let(:params) { { article: attributes_for(:article) } }
    let(:current_user) { create(:user) }
    before { allow_any_instance_of(Api::V1::BaseApiController).to receive(:current_user).and_return(current_user) }

    context "when updating an article owned by the current user" do
      let(:article) { create(:article, user: current_user) }

      it "updates the article" do
        expect { subject }.to change { article.reload.title }.from(article.title).to(params[:article][:title]) &
                              change { article.reload.body }.from(article.body).to(params[:article][:body])
        expect(response).to have_http_status(:ok)
      end
    end

    context "when updating an article not owned by the current user" do
      let(:other_user) { create(:user) }
      let!(:article) { create(:article, user: other_user) }

      it "raises RecordNotFound error" do
        expect { subject }.to raise_error(ActiveRecord::RecordNotFound)
      end
    end
  end
end
