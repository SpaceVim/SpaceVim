guard :shell do
  watch(/(autoload|plugin|t)\/.+\.vim$/) do |m|
    `rake test`
  end
end
