class Api::V1::ArticlesController < ApplicationController
  def index
    articles = Article.order(updated_at: :desc)
    render json: articles, each_serializer:
    Api::V1::ArticlePreviewSerializer
  end

  def show
    article = Article.find_by(id: params[:id])
    if article
      render json: article
    else
      head :not_found
    end
  end

  def create
    article = Article.new(article_params)
    article.user = User.first # 仮置き（Task8でcurrent_userに変更）

    if article.save
      render json: article, status: :created
    else
      render json: { errors: article.errors.full_messages }, status: :unprocessable_entity
    end
  end

  def update
    article = Article.find(params[:id])

    if article.update(article_params)
      render json: article
    else
      render json: { errors: article.errors.full_messages }, status: :unprocessable_entity
    end
  end

  def destroy
    article = Article.find(params[:id])
    article.destroy!
    head :no_content
  end

private

  def article_params
    params.require(:article).permit(:title, :body)
  end
end
