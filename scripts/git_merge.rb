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

puts "🔀 Merging develop into main..."
run("git checkout main")
run("git merge --no-ff develop")

puts "📤 Pushing main branch to remote..."
run("git push origin main")

puts "✅ Merge process complete."
