class VideoDecorator < Draper::Decorator
  delegate_all

  def rating
    object.reviews.count == 0 ? 'N/A' : "#{object.rating}/5.0"
  end
end
