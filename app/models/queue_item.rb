class QueueItem < ActiveRecord::Base
  belongs_to :user
  belongs_to :video

  validates_presence_of :list_order, :user, :video

  def video_title
    video.title
  end

  def category
    video.category
  end

  def category_name
    category.name
  end

  def rating
    review = Review.where(user: user, video: video).first

    review.rating if review
  end
end