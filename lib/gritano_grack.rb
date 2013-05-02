require 'rack'

module Gritano
  module Grack
    class Config
      def initialize
        @config = YAML::load(File.open(File.join(File.dirname(__FILE__), '../config.yml')))
      end

      def gritano_path
        @config['gritano_path']
      end

      def repo_path
        @config['repo_path']
      end
    end

    class Auth < Rack::Auth::Basic
      def call(env)
        auth = Rack::Auth::Basic::Request.new(env)

        return unauthorized unless auth.provided?

        return bad_request unless auth.basic?

        if valid?(auth)
          env['REMOTE_USER'] = auth.username

          return @app.call(env)
        end

        unauthorized
      end

      def valid?(auth)
        env = auth.instance_variable_get("@env")
        repo = /^\/(.*\.git)/.match(env["REQUEST_PATH"])[1]
        access = :wrong
        if env["QUERY_STRING"] == "service=git-upload-pack"
          access = :read
        elsif env["QUERY_STRING"] == "service=git-receive-pack"
          access = :write
        end

        config = Gritano::Grack::Config.new
        if Gritano::CLI.check_access(auth.username, repo, access, config.gritano_path, config.repo_path)
          super
        else
          false
        end
      end
    end
  end
end