module ApplicationHelper

  def video_large_cover(video)
    video.large_cover_url.blank? ? 'http://dummyimage.com/665x375/000000/00a2ff' : video.large_cover_url
  end

  def options_for_video_review(selected=nil)
    options_for_select( (1..5).map { |num| [pluralize(6-num, 'Star'), 6-num] }, selected)
  end

end
