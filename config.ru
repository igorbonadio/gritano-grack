$LOAD_PATH.unshift File.expand_path(File.dirname(__FILE__) + '/lib')

use Rack::ShowExceptions

require 'grack'
require 'git_adapter'
require 'gritano_grack'

gritano_config = Gritano::Grack::Config.new('config.yml')

config = {
  :project_root => gritano_config.repo_path,
  :adapter => Grack::GitAdapter,
  :git_path => '/usr/bin/git',
  :upload_pack => true,
  :receive_pack => true,
}

run Grack::App.new(config)
