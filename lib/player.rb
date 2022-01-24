# typed: false
module Fly
  module PlayerHelper
    def player(torrent_url,player="iina")
      command = "webtorrent '#{torrent_url}' --#{player}"
      exec command
    end
  end
end
