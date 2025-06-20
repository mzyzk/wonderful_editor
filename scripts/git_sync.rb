#!/usr/bin/env ruby

def run(cmd)
  puts "▶ #{cmd}"
  system(cmd)
  unless $?.success?
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
