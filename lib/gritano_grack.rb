module Gritano
  module Grack
    class Config
      def initialize(filename)
        @config = YAML::load(File.open(filename))
      end

      def gritano_path
        @config['gritano_path']
      end

      def repo_path
        @config['repo_path']
      end
    end
  end
end