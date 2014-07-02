class User < ActiveRecord::Base
  has_secure_password validations: false

  validates :email, presence: true, uniqueness: true
  validates :password, presence: true, length: { minimum: 4 }, on: :create
  validates :password, allow_blank: true, length: { minimum: 4 }, on: :update
  validates :full_name, presence: true

  has_many :queue_items, -> { order 'list_order asc' }

  def normalize_queue_items
    self.queue_items.each_with_index do |queue_item, idx|
      queue_item.update(list_order: idx+1)
    end
  end

  def queue_video(video)
    queue_item = self.queue_items.build(list_order: new_queue_order, video: video)
    queue_item.save
  end

  private

  def new_queue_order
    self.queue_items.count + 1
  end

end