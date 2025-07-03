def show_status(env = nil)
  puts "\n===== #{env || "development"} 環境のマイグレーションステータス ====="
  cmd = "bundle exec rails db:migrate:status"
  cmd = "RAILS_ENV=#{env} #{cmd}" if env
  system(cmd)
end

show_status # development
show_status("test")
