# spec/requests/api/v1/articles/drafts_spec.rb
describe "GET /api/v1/articles/drafts" do
  it "returns only current_user's draft articles" do
    me = create(:user)
    other = create(:user)
    create(:article, :draft, user: me)
    create(:article, :draft, user: other)

    get "/api/v1/articles/drafts", headers: me.create_new_auth_token
    json = JSON.parse(response.body)
    expect(json.size).to eq(1)
  end
end

describe "GET /api/v1/articles/drafts/:id" do
  it "returns current_user's draft article" do
    me = create(:user)
    article = create(:article, :draft, user: me)

    get "/api/v1/articles/drafts/#{article.id}", headers: me.create_new_auth_token
    json = JSON.parse(response.body)
    expect(json["id"]).to eq(article.id)
  end
end
