# == Schema Information
#
# Table name: article_likes
#
#  id         :bigint           not null, primary key
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  article_id :bigint           not null
#  user_id    :bigint           not null
#
# Indexes
#
#  index_article_likes_on_article_id  (article_id)
#  index_article_likes_on_user_id     (user_id)
#
# Foreign Keys
#
#  fk_rails_...  (article_id => articles.id)
#  fk_rails_...  (user_id => users.id)
#
require "rails_helper"

RSpec.describe ArticleLike, type: :model do
  describe "バリデーション" do
    context "有効な場合" do
      it "同じユーザーが別の記事にいいねできる" do
        user = create(:user)
        article1 = create(:article)
        article2 = create(:article)
        create(:article_like, user: user, article: article1)
        like = build(:article_like, user: user, article: article2)

        expect(like).to be_valid
      end
    end

    context "無効な場合" do
      it "同じユーザーが同じ記事に2回いいねしようとすると無効" do
        user = create(:user)
        article = create(:article)

        create(:article_like, user: user, article: article)
        duplicate = build(:article_like, user: user, article: article)

        expect(duplicate).not_to be_valid
        expect(duplicate.errors[:user_id]).to include("has already been taken")
      end

      it "ユーザーがnilだと無効" do
        like = build(:article_like, user: nil)
        expect(like).not_to be_valid
        expect(like.errors[:user]).to include("must exist")
      end

      it "記事がnilだと無効" do
        like = build(:article_like, article: nil)
        expect(like).not_to be_valid
        expect(like.errors[:article]).to include("must exist")
      end
    end
  end
end
