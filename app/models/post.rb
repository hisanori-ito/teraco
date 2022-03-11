class Post < ApplicationRecord
  
  belongs_to :user
  has_many :comments, dependent: :destroy
  has_many :favorites, dependent: :destroy
  
  # carrierwave tumbnail用の記述
  mount_uploader :thumbnail, ThumbnailUploader
  # carrierwave video用の記述
  mount_uploader :video, VideoUploader
  
  # いいね用のメソッド
  def favorited_by?(user)
    favorites.exists?(user_id: user.id)
  end
end
