# == Schema Information
#
# Table name: articles
#
#  id         :bigint           not null, primary key
#  body       :text
#  title      :string
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  user_id    :bigint           not null
#
# Indexes
#
#  index_articles_on_user_id  (user_id)
#
# Foreign Keys
#
#  fk_rails_...  (user_id => users.id)
#
require "rails_helper"

RSpec.describe Article, type: :model do
  describe "バリデーション" do
    context "有効な場合" do
      it "すべての属性が正しければ有効である" do
        article = build(:article)
        expect(article).to be_valid
        # 渡す時はシンボルだとインスタンスじゃないので注意！
      end
    end

    context "無効な場合" do
      it "タイトルが空だと無効である" do
        article = build(:article, title: nil)
        expect(article).not_to be_valid
        expect(article.errors[:title]).to include("can't be blank")
      end

      it "タイトルが100字を超えると無効である" do
        article = build(:article, title: "a" * 101)
        expect(article).not_to be_valid
        expect(article.errors[:title]).to include("is too long (maximum is 100 characters)")
      end

      it "本文が空だと無効である" do
        article = build(:article, body: nil)
        expect(article).not_to be_valid
        expect(article.errors[:body]).to include("can't be blank")
      end

      it "本文が500字を超えると無効である" do
        article = build(:article, body: "a" * 501)
        expect(article).not_to be_valid
        expect(article.errors[:body]).to include("is too long (maximum is 500 characters)")
      end
    end
  end
end
