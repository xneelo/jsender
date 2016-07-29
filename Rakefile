task :default => :test

task :test do
  sh %{bundle install}
  sh %{bundle exec rspec -cfd spec}
end