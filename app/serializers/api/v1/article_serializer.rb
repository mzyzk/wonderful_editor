class Api::V1::ArticleSerializer < ActiveModel::Serializer
  attributes :id, :title, :body, :created_at, :updated_at, :user_name

  def user_name
    object.user.name
  end
end
