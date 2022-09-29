class TracksController < ApplicationController
  def show
    @track = Track.find(params[:id])
    @track_info = audio(@track)
  end

  private

  def audio(object)

    track = case_down_remove_spaces(object.title)
    album = case_down_remove_spaces(object.album)
    artist = case_down_remove_spaces(object.band)

    track_info = find_track(track,album, artist)
    
    begin
      return @track_infos = track_info.first[1].first["preview"]
    rescue => exception
      puts "$"*50 
      puts exception
      flash[:alert] = 'Track not found'
      return render action: :show
    end
  end

  def request_api(url)
    response = HTTP.get(url)
    return nil if response.status != 200
    JSON.parse(response)
  end

  def find_track(track, album, artist)
    request_api(
    "https://api.deezer.com/search?q=track:'#{track}'%album:'#{album}'%artist:'#{artist}'"
    )
  end

  def case_down_remove_spaces(string)
    string.downcase.gsub("_", "%")
  end
end
