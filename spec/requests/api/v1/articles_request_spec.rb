# spec/requests/api/v1/articles_request_spec.rb
require "rails_helper"

RSpec.describe "Api::V1::Articles", type: :request do
  # omitted

  describe "POST /articles" do
    subject { post(api_v1_articles_path, params: params, headers: headers) }

    let(:params) { { article: attributes_for(:article) } }
    let(:current_user) { create(:user) }

    # stub
    let(:headers) { current_user.create_new_auth_token.compact }

    it "creates a new article record" do
      expect { subject }.to change { Article.where(user_id: current_user.id).count }.by(1)
      res = JSON.parse(response.body)
      expect(res["title"]).to eq params[:article][:title]
      expect(res["body"]).to eq params[:article][:body]
      expect(response).to have_http_status(:ok)
    end
  end

  describe "PATCH /api/v1/articles/:id" do
    subject { patch(api_v1_article_path(article.id), params: params, headers: headers) }

    let(:params) { { article: attributes_for(:article) } }
    let(:current_user) { create(:user) }
    let(:headers) { current_user.create_new_auth_token.compact }

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

  describe "DELETE /articles/:id" do
    subject { delete(api_v1_article_path(article.id), headers: headers) }

    # To be removed after devise_token_auth is implemented
    let(:current_user) { create(:user) }
    let(:article_id) { article.id }
    let(:headers) { current_user.create_new_auth_token.compact }

    context "when the user tries to delete their own article" do
      let!(:article) { create(:article, user: current_user) }

      it "deletes the article" do
        expect { subject }.to change { Article.count }.by(-1)
        expect(response).to have_http_status(:no_content)
      end
    end

    context "when the user tries to delete someone else's article" do
      let(:other_user) { create(:user) }
      let!(:article) { create(:article, user: other_user) }

      it "does not delete the article" do
        expect { subject }.to raise_error(ActiveRecord::RecordNotFound) &
                              change { Article.count }.by(0)
      end
    end
  end
end
