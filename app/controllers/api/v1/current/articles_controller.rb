# app/controllers/api/v1/current/articles_controller.rb
module Api
  module V1
    module Current
      class ArticlesController < BaseApiController
        before_action :authenticate_user!

        def index
          articles = current_user.articles.published.order(updated_at: :desc)
          render json: articles, each_serializer: Api::V1::ArticlePreviewSerializer
        end
      end
    end
  end
end
