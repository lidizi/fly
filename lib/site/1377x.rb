module Fly
  module Search
    module S1377XSite
      def site 
        "https://www.1377x.to"
      end
      def headers 
        {}
      end
      def search(kw)
        # https://www.1377x.to/search/12/1/
        Fly::Log.info(self,"site 1111111=> #{site}")
        results = []
        request("#{site}/search/#{kw}/1/",headers: headers) do | res |
          doc = Nokogiri::HTML.parse(res.to_s)
          results = doc.xpath("//table/tbody/tr").map do | tr | 
            title_tag = tr.xpath('td[@class="coll-1 name"]').first
            title = title_tag.content
            href = title_tag.xpath("a").last.attributes["href"]
            hot = tr.xpath('td[@class="coll-2 seeds"]').first.content
            date = tr.xpath('td[@class="coll-date"]').first.content
            size = tr.xpath('td[@class="coll-4 size mob-uploader"]').first.content
            SearchItem.new(
              id: Fly.next_id,
              site: site,
              url: site + href,
              title: title.strip,
              date: date,
              hot: hot,
              size: size,
              summary: '',
              file_type: '未知'
            )
            data = { 
              site: site,
              url: site + href,
              title: title.strip,
              date: date,
              hot: hot,
              size: size,
              desc: '',
              type: '未知'
            } 
            desc = fill(data)
            data[:desc] = desc
            data
          end
        end
        results
      end
      def torrent(url)
        request(url,headers: headers) do | res |
          doc = Nokogiri::HTML.parse(res.body.to_s)
          torrent = doc.xpath('//a').map{|tag| 
            href = tag.attributes["href"]
            return href if href =~ /^magnet:/
            nil
          }.compact.first
          Fly::Log.error(self,torrent)
          torrent
        end
      end
    end
  end
end
