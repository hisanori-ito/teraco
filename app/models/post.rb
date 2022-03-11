class Post < ApplicationRecord
  
  belongs_to :user
  
  # carrierwave用の記述
  mount_uploader :thumbnail, ThumbnailUploader
end
