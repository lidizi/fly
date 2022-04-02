module Fly
  class Configure 
    def initialize(path = Fly.root)
      @config_hash = load_config
    end
    def load_config 
      YAML.load(File.open(path))
    end
    def config_hash 
      @configure_hash ||= load_config
    end
    def aria2_config 
      @config_hash[:fly][:download].nil?
    end
  end
end