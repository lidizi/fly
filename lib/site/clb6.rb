# typed: false
module Fly 
  module Search
    module SCLB6Site
      def site 
        "http://clb6.cc"
      end
      def headers 
        response = HTTP.get(site)
        cookies = response.headers['Set-Cookie']
        agent = "Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:96.0) Gecko/20100101 Firefox/96.0"
        { 
          "Host": "clb6.cc",
          "User-Agent": agent,
          "Cookie": "Challenge=#{Digest::MD5.hexdigest(agent)}; "+ cookies.split(';').first
        }
      end
      def search(kw)
        results = []
        request("#{site}/s/#{kw}.html",headers: headers) do | res |
          return [] if res.nil?
          doc = Nokogiri::HTML.parse(res.to_s)
          results = doc.xpath('//div[@class="search-item"]').map do | item |
            begin
            title_tag = item.xpath('div[@class="item-title"]').first
            href = title_tag.to_s.scan(%r(href="(.*)?"))[0][0]
            title = title_tag.content
            next unless href =~ %r(^/detail.*\.html)
            file_info = item.xpath('div[@class="item-bar"]/span')
            desc = item.xpath('div[@class="item-list"]').first.content
            next unless file_info.size == 4
            if file_info 
              file_type = file_info[0].content if file_info[0]
              create_date = file_info[1].content if file_info[1]
              file_size = file_info[2].content if file_info[2]
              file_hot = file_info[3].content if file_info[3]
            end
            SearchItem.new( site: site, summary: desc, url: site + href, title: title, date: create_date, file_type: file_type, size: file_size.strip, hot: file_hot,)
            end
          end
        end
        results
      end
      def torrent(url)
        request(url,headers: headers) do | res |
          doc = Nokogiri::HTML.parse(res.body.to_s)
          a_tag = doc.xpath('//a[@id="down-url"]').first
          a_doc = Nokogiri::HTML.parse(a_tag.to_s)
          torrent = a_doc.xpath("//a/@href").to_s
          Fly::Log.info(self,torrent)
          torrent
        end
      end
    end
  end
end
