class Review < ActiveRecord::Base
  belongs_to :video
  belongs_to :user

  validates :content, presence: true, unless: :omit_content
  validates :rating, presence: true, numericality: { only_integer: true, greater_than: 0, less_than_or_equal_to: 5 }

  attr_accessor :omit_content
end