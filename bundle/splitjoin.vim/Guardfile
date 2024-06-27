guard 'rspec', cmd: 'bundle exec rspec' do
  watch(%r{autoload/sj/(.*)\.vim}) { |m| "spec/plugin/#{m[1]}_spec.rb"}
  watch(%r{spec/plugin/(.*)_spec.rb})
end
