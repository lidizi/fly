module Fly 
  module Download 
    class Base 
      include Fly::HTTPHelper
    end
  end
  class DownloadEngines
    def self.download_engines(name)
      downloader = nil
      case name.downcase
      when "aria2"
        downloader = Download::Aria2.new
      when "webtorrent"
        downloader = Download::WebTorrent.new
      else 
        downloader = Download::Aria2.new
      end
      downloader
    end
    attr_accessor :downloader
    def initialize(name)
      @downloader = DownloadEngines.download_engines(name)
      Fly::Log.info(self,"initialize => #{self.class} downloader => #{@downloader.class}")
    end
    def download(url,options = {})
      @downloader.download(url,options)
    end
    def player? 
      @downloader.player?
    end
  end
end
