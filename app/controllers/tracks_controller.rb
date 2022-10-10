class TracksController < ApplicationController
  def show
      @track = Track.find(params[:id])
      @track_modified = rename(@track)
  end

  private 

  def rename(track)
    song = format_link(track.title)
    album = format_link(track.album)
    band = format_link(track.band)

    return {title: song, album: album, band: band}
  end

  def format_link(string)
    string.gsub("_", "%20").downcase()
  end

end
