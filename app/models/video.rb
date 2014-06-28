class Video < ActiveRecord::Base
  validates :title, presence: true
  validates :description, presence: true

  belongs_to :category

  def self.search_by_title(search_title)
    return [] if search_title.blank?
    where("title LIKE ?", "%#{search_title}%").order('created_at desc')
  end
end