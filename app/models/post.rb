class Post < ApplicationRecord

  belongs_to :user
  has_many :comments, dependent: :destroy
  has_many :favorites, dependent: :destroy
  has_many :bookmarks, dependent: :destroy
  has_many :notifications, dependent: :destroy
  
  has_rich_text :content

  validates :title, presence: true
  validates :content, presence: true
  validate :validate_tag

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

  # タグ記録用
  def attach_tags(tag_strings)
    tag_strings.each do |new|
      new_post_tag = Tag.find_or_initialize_by(name: new)
      post_tags.build({tag: new_post_tag})
    end
  end

  #タグ編集用の記述
  def fix_tags(tag_strings)
      current_tags = self.tags.pluck(:name) unless self.tags.nil?
      old_tags = current_tags - tag_strings
      new_tags = tag_strings - current_tags

      old_tags.each do |old|
        self.tags.delete Tag.find_by(name: old)
      end
      
      new_tags.each do |new|
        new_post_tag = Tag.find_or_initialize_by(name: new)
        post_tags.build({tag: new_post_tag})
      end
  end

  #余計なタグを残さない
  def destroy_tag
    tags = Tag.all
      tags.each do |tag|
        if tag.posts.count == 0
          tag.destroy
        end
      end
  end

  #タグバリデーションチェック
  def validate_tag
    if post_tags.size == 0
      errors.add(:🏷, "タグを入力してください")
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
    # ↓いいねされているか確認する
    temp = Notification.where(["from_user_id = ? and to_user_id = ? and post_id = ? and action = ? ", current_user.id, user_id, id, "favorite"])
    # ↓いいねされていない場合通知レコードを作成
    if temp.blank?
      notification = current_user.from_me_notifications.new(
        post_id: id,
        to_user_id: user_id,
        action: "favorite"
      )
      # ↓自分の投稿に対するいいねは、通知済みとする
      if notification.from_user_id == notification.to_user_id
        notification.checked = true
      end
      notification.save if notification.valid?
    end
  end

  # コメント通知用メソッド
  def notification_comment!(current_user, comment_id)
    # ↓自分以外にコメントしている人をすべて取得し全員に通知を送る
    temp_ids = Comment.select(:user_id).where(post_id: id).where.not(user_id: current_user.id).distinct
    temp_ids.each do |temp_id|
      save_notification_comment!(current_user, comment_id, temp_id['user_id'])
    end
    save_notification_comment!(current_user, comment_id, user_id) if temp_ids.blank?
  end

  def save_notification_comment!(current_user, comment_id, to_user_id)
    # コメントは複数回することが考えられるため１つの投稿に複数回通知する
    notification = current_user.from_me_notifications.new(
      post_id: id,
      comment_id: comment_id,
      to_user_id: to_user_id,
      action: "comment"
    )
    # 自分の投稿に対するコメントの場合は、通知済みとする
    if notification.from_user_id == notification.to_user_id
      notification.checked = true
    end
    notification.save if notification.valid?
  end

  # PageView用の追記
  is_impressionable counter_cache: true
end
