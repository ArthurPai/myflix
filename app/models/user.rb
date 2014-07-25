class User < ActiveRecord::Base
  include Tokenable
  has_secure_password validations: false

  validates :email, presence: true, uniqueness: true
  validates :password, presence: true, length: { minimum: 4 }, on: :create
  validates :password, allow_blank: true, length: { minimum: 4 }, on: :update
  validates :full_name, presence: true

  has_many :queue_items, -> { order 'list_order asc' }
  has_many :reviews, -> { order 'created_at desc'}

  has_many :fellowships, foreign_key: :follower_id
  has_many :followed_users, through: :fellowships

  has_many :inverse_fellowships, class_name: 'Fellowship', foreign_key: :followed_user_id
  has_many :followers, through: :inverse_fellowships

  tokenable_column :reset_password_token
  after_create :generate_invitation_token

  def normalize_queue_items
    queue_items.each_with_index do |queue_item, idx|
      queue_item.update(list_order: idx+1)
    end
  end

  def queue_video(video)
    queue_item = queue_items.build(list_order: new_queue_order, video: video)
    queue_item.save
  end

  def queued_video?(video)
    queue_items.map(&:video).include?(video)
  end

  def can_follow?(user)
    user && !(user == self || following?(user))
  end

  def following?(user)
    followed_users.include?(user)
  end

  def generate_invitation_token
    update_column(:invitation_token, SecureRandom.urlsafe_base64)
  end

  def deactivate!
    update_column(:active, false)
  end

  private

  def new_queue_order
    queue_items.count + 1
  end
end