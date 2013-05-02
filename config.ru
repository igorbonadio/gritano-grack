$LOAD_PATH.unshift File.expand_path(File.dirname(__FILE__) + '/lib')

use Rack::ShowExceptions

require 'grack'
require 'git_adapter'
require 'gritano'
require 'gritano_grack'

gritano_config = Gritano::Grack::Config.new('config.yml')

use Rack::Auth::Basic, "Gritano" do |username, password|
  Gritano::CLI.check_password(username, password, gritano_config.gritano_path, gritano_config.repo_path)
end

config = {
  :project_root => gritano_config.repo_path,
  :adapter => Grack::GitAdapter,
  :git_path => '/usr/bin/git',
  :upload_pack => true,
  :receive_pack => true,
}

run Grack::App.new(config)
