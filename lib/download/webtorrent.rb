module Fly 
  module Download
    class WebTorrent < Base
      attr_accessor :default_options
      def initialize(options = {})
        @default_options = options
      end
      def player? 
        true
      end
      def download(torrent,options = {})
        @default_options = @default_options.merge(options)
        command = ["webtorrent '#{torrent}'"]
        command.push("--#{options[:player]}") if options.include? :player
        system command.join(" ")
      end
    end
  end
end
