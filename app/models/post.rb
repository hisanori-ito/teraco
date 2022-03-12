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
  
  # tag用の記述
  has_many :post_tags, dependent: :destroy
  has_many :tags, through: :post_tags
  
  
  def save_tag(sent_tags)
    current_tags = self.tags.pluck(:name) unless self.tags.nil?
    old_tags = current_tags - sent_tags
    new_tags = sent_tags - current_tags
    
    old_tags.each do |old|
      self.tags.delete Tag.find_by(name: old)
    end
    
    new_tags.each do |new|
      new_post_tag = Tag.find_or_create_by(name: new)
      self.tags << new_post_tag
   end
  end
end
