#!/usr/bin/env ruby
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
require 'clipboard'
require 'active_support'
require 'tty-prompt'
require 'optparse'

require 'yaml'
libs = File.expand_path File.join(File.dirname(__FILE__),'lib','**/*.rb')
Dir[libs].sort.each do | lib | 
  require lib
end
# require 'bencode/bencode'modul 

module Fly 
  def root 
    @@root ||= Pathname.new(__FILE__).realdirpath
  end
  def self.next_id 
    @@id = @@id.next || 0
  end
  def self.context 
    @@context ||= FlyContext.new
  end

  def self.copy(str)
      begin
        ClipBoard.copy(str)
      rescue 
        puts str
      end
    end
  def self.search(kw,options = {})
    data = self.context.search(kw,options).map do |res|
      title = "[#{res.site}]|[#{res.hot}]|[#{res.size}]|#{res.title}"
      {name: title[0..(title.length > 80 ? 80 : title.length)],url: res.url,item: res}
    end
    selected = self.select data
    if options[:download] 

    else 
      selected.each do |item|
        self.copy(self.context.torrent item)
      end
    end
  end

  def self.select(data)
    prompt = TTY::Prompt.new
    selected = prompt.multi_select("Select a resource.",echo: false,filter: true) do |menu|
      data&.each do |item|
        menu.choice item[:name],item[:item]
      end
    end
  end

  CACHE_DIR = ENV["FLY_CACHE_DIR"] || File.join(ENV["HOME"],".cache","fly")

  class FlyContext
    include Fly::Core
    include Fly::HTTPHelper
    attr_accessor :is_down,:is_player,:cache_dir,:kw,:search_cache,:downloader,:selected,:screen,:system,:search_engines
    def initialize 
      @search_cache = false
      @is_down = true
      @search_engines = SearchEngines.new
      @download_engines = DownloadEngines.new("webtorrent")
      # @system = System.new
      @data = []
    end
    def download_options
      { 
        player: "iina"
      }
    end
    def add_search_result(result)
      if result.kind_of? Array 
        @data = @data + result if result.kind_of? Array
      else 
        @data << result
      end
    end

    def search_result
      @data
    end
    def search(kw,options={})
      @search_engines.search(kw,options)
    end
    def initialize_downloader
      @downloader = DownloadAdapter.download_engine("webtorrent",download_options)
    end
    def download(url,options = {})
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

options = {}
parser = OptionParser.new do |opts|
  # opts.banner "Search torrent source"
  opts.on("-d","--download [DOWNLOAD]","download engine") do |download|
    options[:download] = download
  end

  opts.on("-s","--search [KEYWORD]") do |search|
    options[:keyword] = search
  end
  opts.on("-S","--site [SITE]") do |site|
    options[:site] = site
  end

  opts.on("-v","--version") do |version |
    options[:version] = true
  end
end

parser.parse!
puts options

raise "keyword cannot be null." unless options.include?(:keyword)
Fly.search options[:keyword]
