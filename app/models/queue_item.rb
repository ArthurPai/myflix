class QueueItem < ActiveRecord::Base
  belongs_to :user
  belongs_to :video

  validates_presence_of :list_order, :user, :video
  validates_uniqueness_of :video_id, scope: :user_id

  delegate :category, to: :video
  delegate :title, to: :video, prefix: :video
  delegate :name, to: :category, prefix: :category

  def rating
    review = Review.where(user: user, video: video).first

    review.rating if review
  end
end