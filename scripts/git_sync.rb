#!/usr/bin/env ruby

require "English"
def run(cmd)
  puts "▶ #{cmd}"
  system(cmd)
  unless $CHILD_STATUS.success?
    puts "❌ Command failed: #{cmd}"
    exit(1)
  end
end

puts "🔄 Syncing main branch..."
run("git checkout main")
run("git pull origin main")

puts "🔄 Syncing develop branch..."
run("git checkout develop")
run("git pull origin develop")

puts "✅ Sync complete."
