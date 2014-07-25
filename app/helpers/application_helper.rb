module ApplicationHelper
  def options_for_video_review(selected=nil)
    options_for_select( (1..5).map { |num| [pluralize(6-num, 'Star'), 6-num] }, selected)
  end
end
