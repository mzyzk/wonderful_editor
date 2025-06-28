module Api
  module V1
    class ArticlesController < ApplicationController
      def index
        render json: { message: "API is working!" }
      end
    end
  end
end
