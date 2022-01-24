# typed: false
module Fly 
  module Download
    class Default < Base
      def download_torrent(url)
      end
      def each_piece(info)
        piece_length = info["piece length"]
        if info.include?("files")
          piece = ''
          info["files"].each do | file_info |
            fp = File.join(info['name'],file_info["path"])
          end
          else 
          fp = info['name']
          File.open(fp,'rb') do | f |
          end
        end
      end
      #      def parse_torrent(torrent)
      #        meta_data = Bencode.decode_file(torrent)
      #        return if meta_data.nil?
      #        info = meta_data['info']
      #        pieces = StringIO.new(info['pieces'])
      #        each_piece(info)
      #      end
    end
  end
end
