class Post < ApplicationRecord

  belongs_to :user
  has_many :comments, dependent: :destroy
  has_many :favorites, dependent: :destroy
  has_many :bookmarks, dependent: :destroy
  has_many :notifications, dependent: :destroy

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

  # 検索用の記述
  def self.search(word)
    where(["title like? OR content like?", "%#{word}%", "%#{word}%"])
  end

  # ブックマーク用のメソッド
  def bookmarked?(user)
    bookmarks.where(user_id: user).exists?
  end
  
  # いいね通知用メソッド
  def notification_favorite!(current_user)
    temp = Notification.where(["from_user_id = ? and to_user_id = ? and post_id = ? and action = ? ", current_user.id, user_id, id, 'favorite'])
    # いいねされていない場合のみ、通知レコードを作成
    if temp.blank?
      notification = current_user.from_me_notifications.new(
        post_id: id,
        to_user_id: user_id,
        action: 'favorite'
      )
      # 自分の投稿に対するいいねの場合は、通知済みとする
      if notification.from_user_id == notification.to_user_id
        notification.checked = true
      end
      notification.save if notification.valid?
    end
  end
  
  # コメント通知用メソッド
  def notification_comment!(current_user, comment_id)
    # 自分以外にコメントしている人をすべて取得し、全員に通知を送る
    temp_ids = Comment.select(:user_id).where(post_id: id).where.not(user_id: current_user.id).distinct
    temp_ids.each do |temp_id|
      save_notification_comment!(current_user, comment_id, temp_id['user_id'])
    end
    save_notification_comment!(current_user, comment_id, user_id) if temp_ids.blank?
  end
  
  def save_notification_comment!(current_user, comment_id, to_user_id)
    # コメントは複数回することが考えられるため、１つの投稿に複数回通知する
    notification = current_user.from_me_notifications.new(
      post_id: id,
      comment_id: comment_id,
      to_user_id: to_user_id,
      action: 'comment'
    )
    # 自分の投稿に対するコメントの場合は、通知済みとする
    if notification.from_user_id == notification.to_user_id
      notification.checked = true
    end
    notification.save if notification.valid?
  end
end
