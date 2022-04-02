module Fly 
class SearchEngines
  @@search_engines = {}
  attr_accessor :sites,:_mutex
  def initialize 
    @_mutex = Thread::Mutex.new
    @sites = []
    Find.find(File.join(File.dirname(__FILE__),'../',"lib")) do | path | 
      @sites.push(File.basename(path).gsub(/\.rb/,'')) if path =~ %r(.*?/site/.*\.rb)
    end
    @@search_engines =  Hash[sites.map { | site |
      # Fly::Log.info(self,"site => #{site}")
      class_name = "Fly::S#{site.upcase}Search" 
      Fly.class_eval (
        <<~RUBY
        class #{class_name} < Fly::Search::Base
          include Fly::Search::S#{site.upcase}Site
          def initialize 
          end
        end
        RUBY
      )
      [site,Object::const_get(class_name).new]
    }.collect{|item| item}]
    Fly::Log.info(self,"initialize => #{self.class} sites => #{@@search_engines.keys.join(",")}")
  end
  # def self.included(mod)
  # end
  def search(kw,options = {})
    results = []
    if options.include?(:site)
      Fly::Log.info(self,"search  #{options[:site]} => #{kw}")
      v = @search_engines[options[:site]]
      v.instance_variable_set("@kw",kw)
      results << v.search(kw)
      else
      @@search_engines.map do | k,v |
        Thread.new do 
          Fly::Log.info(self,"search  #{k} => #{kw}")
          v.instance_variable_set("@kw",kw)
          result = v.search(kw)
          @_mutex.synchronize { 
            results = results + result
          }
        end
      end.each(&:join)
    end
    results
  end
  def torrent(item)
    site,url = item.site,item.url
    site = site.gsub(%r{http:\/\/|https:\/\/|www\.|\..*?$},'')
    Fly::Log.info(self," site => #{site} url => #{url} search engine => #{SearchEngines.instance_engine(site)}")
    SearchEngines.instance_engine(site).torrent(url)
    # self.instance_engine(item[:site]).torrent(item[:url])
  end
  def self.instance_engine(name)
      Fly::Log.info(self," name => #{name}")
    @@search_engines[name] 
  end
end
module Search 
  class SearchItem 
    attr_accessor :id,:site,:url,:title,:size,:hot,:summary,:file_type,:date
    def initialize(**options)
      @id = options.delete(:id)
      @site = options.delete(:site)
      @url = options.delete(:url)
      @title = options.delete(:title)
      @size = options.delete(:size)
      @hot = options.delete(:hot)
      @summary = options.delete(:summary)
      @file_type = options.delete(:file_type)
      @date = options.delete(:date)
    end
    def to_h 
      hash = {}
      instance_variables.each {|var| hash[var.to_s.delete("@")] = instance_variable_get(var) }
      hash
    end
    def render
      fill(to_h)
    end
  end
  class Base
    include Fly::HTTPHelper
    attr_accessor :kw,:results,:headers,:log
    def initialize 
      @log = Fly.logger_for(self)
    end
    def search(kw)
    end
    def headers 
    end
  end
  end
end
