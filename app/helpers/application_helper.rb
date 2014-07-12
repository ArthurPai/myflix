module ApplicationHelper

  def video_large_cover(video)
    video.large_cover_url || 'holder.js/665x375/#000:#fff/text:Large Cover'
  end

  def video_small_cover(video)
    video.small_cover_url || 'holder.js/166x236/sky/text:Cover'
  end

  def options_for_video_review(selected=nil)
    options_for_select( (1..5).map { |num| [pluralize(6-num, 'Star'), 6-num] }, selected)
  end

end
