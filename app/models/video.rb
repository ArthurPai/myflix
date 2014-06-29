class Video < ActiveRecord::Base
  belongs_to :category
  has_many :reviews, -> { order 'created_at desc' }

  validates :title, presence: true
  validates :description, presence: true

  def self.search_by_title(search_title)
    return [] if search_title.blank?
    where("title LIKE ?", "%#{search_title}%").order('created_at desc')
  end
end