gem 'data_miner', :path => ENV['LOCAL_DATA_MINER'] if ENV['LOCAL_DATA_MINER']
gem 'mini_record', :path => ENV['LOCAL_MINI_RECORD'] if ENV['LOCAL_MINI_RECORD']
gem 'force_schema', :path => ENV['LOCAL_FORCE_SCHEMA'] if ENV['LOCAL_FORCE_SCHEMA']

source :rubygems

gemspec :path => '.'

if RUBY_VERSION < "1.9"
  gem 'fastercsv'
end
