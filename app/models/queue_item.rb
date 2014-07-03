class QueueItem < ActiveRecord::Base
  belongs_to :user
  belongs_to :video

  validates_presence_of :list_order, :user, :video
  validates_uniqueness_of :video_id, scope: :user_id
  validates_numericality_of :list_order, { only_integer: true }

  delegate :category, to: :video
  delegate :title, to: :video, prefix: :video
  delegate :name, to: :category, prefix: :category

  def rating
    review.rating if review
  end

  def rating=(num)
    if review
      review.update_column(:rating, num)
    else
      Review.create(rating: num, user: user, video: video, omit_content: true)
    end
  end

  def review
    @review ||= Review.where(user: user, video: video).first
  end
end