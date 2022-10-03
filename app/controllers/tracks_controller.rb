class TracksController < ApplicationController
    def show
        @track = Track.find(params[:id])
        @track_modified = rename(@track)
    end

    private 

    def rename(track)
      song = track.title.gsub("_", "%20").downcase()
      album = track.album.gsub("_", "%20").downcase()
      band = track.band.gsub("_", "%20").downcase()

      return {title: song, album: album, band: band}
    end
end
