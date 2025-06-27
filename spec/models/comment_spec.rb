# == Schema Information
#
# Table name: comments
#
#  id         :bigint           not null, primary key
#  body       :text
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  article_id :bigint           not null
#  user_id    :bigint           not null
#
# Indexes
#
#  index_comments_on_article_id  (article_id)
#  index_comments_on_user_id     (user_id)
#
# Foreign Keys
#
#  fk_rails_...  (article_id => articles.id)
#  fk_rails_...  (user_id => users.id)
#
require "rails_helper"

RSpec.describe Comment, type: :model do
  describe "バリデーション" do
    context "有効な場合" do
      it "すべての属性が正しければ有効である" do
        comment = build(:comment)
        expect(comment).to be_valid
      end
    end

    context "無効な場合" do
      it "本文が空だと無効である" do
        comment = build(:comment, body: nil)
        expect(comment).not_to be_valid
        expect(comment.errors[:body]).to include("can't be blank")
      end

      it "本文が300字を超えると無効である" do
        comment = build(:comment, body: "a" * 301)
        expect(comment).not_to be_valid
        expect(comment.errors[:body]).to include("is too long (maximum is 300 characters)")
      end
    end
  end
end
