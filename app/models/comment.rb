class Comment < ApplicationRecord

  belongs_to :user
  belongs_to :post

  has_many :notifications, dependent: :destroy
  
  has_rich_text :comment

  validates :comment, presence: true
end
