class Post < ApplicationRecord
  
  belongs_to :user
  has_many :comments, dependent: :destroy
  
  # carrierwave tumbnail用の記述
  mount_uploader :thumbnail, ThumbnailUploader
  # carrierwave video用の記述
  mount_uploader :video, VideoUploader
end
