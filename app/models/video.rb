class Video < ActiveRecord::Base
  belongs_to :category
  has_many :reviews, -> { order 'created_at desc' }
  has_many :queue_items
  mount_uploader :small_cover, VideoSmallCoverUploader
  mount_uploader :large_cover, VideoLargeCoverUploader

  validates_presence_of :title, :description, :category
  validates_associated :category

  def self.search_by_title(search_title)
    return [] if search_title.blank?
    where("title LIKE ?", "%#{search_title}%").order('created_at desc')
  end

  def rating
    (rating_sum.to_f / reviews.count.to_f).round(1) if reviews.count > 0
  end

  private
    def rating_sum
      reviews.map(&:rating).sum
    end
end