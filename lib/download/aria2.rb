# typed: false
require_relative '../http_helper'
module Fly 
  module Download 
    class Aria2 < Base
      attr_accessor :default_options
      def initialize(options = {})
        @default_options = options
      end
      def player?
        false
      end
      def download(source,options = {})
        start unless started?
        options = (options || {}).merge({ 
          #"bt-stop-timeout": str(STOP_TIMEOUT),
          "max-concurrent-downloads":"10",
        })
        data = [
          [source],
          options
        ]
        aria2_rpc("aria2.addUri",data)
        #status("d7153f5bf5662440")
      end

      private 
      def load_config
        ENV["ARIA_CONF"] ||= "#{ENV["HOME"]}/.aria2/aria2.conf"
      end
      def start
        load_config
        command = "aria2c --conf-path=#{ENV["ARIA_CONF"]} -D"
        system(command)
        sleep 3
      end
      def started?
        arai2_pid == 0 ? false : true
      end
      def status(gid,**options)
        start unless started?
        data = [
          gid,
          options
        ]
        aria2_rpc("aria2.tellStatus",data)
      end
      def arai2_pid
        result = `ps -ef | grep '[a]ria2c' | awk -F' ' '{print $2}'`
        File.open(File.join(Fly::CACHE_DIR,"aria2c.pid"),'w+') do | f |
          f.write(result)
        end
        result.to_i
      end
      def aria2_rpc(method,data)
        host = "127.0.0.1:6800"
        #bff245b0c8b479bf
        #source = options.delete(:source)
        body = { 
          jsonrpc: "2.0",
          id: "fly",
          method: method,
          params: data
        }
        request("http://#{host}/jsonrpc",body: body,method: "POST") do | res |
        end
      end
    end
  end
end
