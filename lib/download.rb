module Fly 
  module Download 
    class Base 
      include Fly::HTTPHelper
    end
  end
  class DownloadEngines
    @@download_engines = {}
    # def self.download_engines(name)
    #   DownloadEngines.download_engines(name)
    # end
    attr_accessor :downloader
    def initialize
      @@download_engines = {
        default: Download::Aria2.new,
        aria2: Download::Aria2.new,
        webtorrent: Download::WebTorrent.new,
      }
    end
    def download(url,options = {})
      _engine = if options[:download]
        options[:download]
      else 
        options[:default]
      end
      @@download_engines[_engine].download(url)
    end
    def player? 
      @downloader.player?
    end
  end
end
