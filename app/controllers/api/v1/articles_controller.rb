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
end
