module ApplicationHelper

    def video_large_cover(video)
      video.large_cover_url.blank? ? 'http://dummyimage.com/665x375/000000/00a2ff' : video.large_cover_url
    end

end
