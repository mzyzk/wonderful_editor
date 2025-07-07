# config/initializers/cors.rb

Rails.application.config.middleware.insert_before 0, Rack::Cors do
  allow do
    origins "*" # 本番では限定すべき
    resource "*",
             headers: :any,
             expose: ["access-token", "expiry", "token-type", "uid", "client"],
             methods: [:get, :post, :put, :patch, :delete, :options, :head]
  end
end
