# test_db_sync.rb

def run_migration(env = nil)
  env_option = env ? "RAILS_ENV=#{env}" : ""
  puts "==> Running migration for #{env || "development"} environment..."
  success = system("bundle exec rails db:migrate #{env_option}".strip)
  unless success
    puts "❌ Migration failed for #{env || "development"}"
    exit(1)
  end
end

run_migration          # development
run_migration("test")  # test

puts "✅ All migrations completed successfully!"
