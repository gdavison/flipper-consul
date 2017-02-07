$:.unshift(File.expand_path('../../lib', __FILE__))

#require 'pathname'
#require 'logger'
#
#root_path = Pathname(__FILE__).dirname.join('..').expand_path
#lib_path  = root_path.join('lib')
#log_path  = root_path.join('log')
#log_path.mkpath
#
require 'rubygems'
require 'bundler'

Bundler.require(:default, :test)

require 'flipper-consul'

#Logger.new(log_path.join('test.log'))

RSpec.configure do |config|
  config.filter_run :focused => true
  config.alias_example_to :fit, :focused => true
  config.alias_example_to :xit, :pending => true
  config.run_all_when_everything_filtered = true
#  config.fail_fast = true
end