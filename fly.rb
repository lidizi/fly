# typed: ignore
# $:.unshift File.expand_path(File.join(File.dirname(__FILE__),'lib'))
require 'http'
require 'json'
require 'find'
require 'byebug'
require 'logger'
require 'nokogiri'
require 'fileutils'
require 'digest'
require 'timeout'
require 'curses'

libs = File.expand_path File.join(File.dirname(__FILE__),'lib','**/*.rb')
Dir[libs].sort.each do | lib | 
  require lib
end
# require 'bencode/bencode'modul 

module Fly 
  def self.next_id 
    @@id = @@id.next || 0
  end
  def self.context 
    @@context ||= FlyContext.new
  end
  CACHE_DIR = ENV["FLY_CACHE_DIR"] || File.join(ENV["HOME"],".cache","fly")
  def self.run
    Fly::Log.info(self,"run..")
    begin
      screen = Screen.new
      screen.render
    rescue StandardError => e
      Fly::Log.error(self,"error #{e}")
    end
  end
  class FlyContext
    include Fly::Core
    include Fly::HTTPHelper
    #include Fly::SearchAdpater
    attr_accessor :is_down,:is_player,:cache_dir,:kw,:search_cache,:downloader,:selected,:screen,:system,:search_engines
    def initialize 
      # @_mutex = Thread::Mutex.new
      # @sites = []
      @search_cache = false
      @is_down = true
      @search_engines = SearchEngines.new
      @download_engines = DownloadEngines.new("webtorrent")
      @system = System.new
    end
    def download_options
      { 
        player: "iina"
      }
    end
    def search(kw)
      @search_engines.search(kw)
    end
    def initialize_downloader
      @downloader = DownloadAdapter.download_engine("webtorrent",download_options)
    end
    def download(url)
      @download_engines.download(url)
    end
    def torrent(item)
      @search_engines.torrent(item)
    end
    def search_cache? 
      @search_cache
    end
    def download?
      @is_down
    end
    def player(url)
      @download_engines.download(url,player: "iina") if @download_engines.player?
    end
    def refresh_cache
      return if search_cache?
      fp = File.join(::CACHE_DIR,"search")
      if File.exist?(fp) && fp.include?('fly')
        FileUtils.remove_dir(fp,true)
      end
    end
  end
end
