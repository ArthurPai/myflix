class Category < ActiveRecord::Base
  validates :name, presence: true

  has_many :videos, -> { order 'title asc' }

  def recent_videos
    Video.where('category_id = ?', id).order('created_at desc').take(6)
  end
end