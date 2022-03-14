class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable,
         # ↓SNS認証用の記述
         :omniauthable, omniauth_providers: %i[facebook twitter google_oauth2]

  has_many :posts, dependent: :destroy
  has_many :comments, dependent: :destroy
  has_many :favorites, dependent: :destroy
  has_many :bookmarks, dependent: :destroy

  # フォロー機能の記述
  # フォローを行うとき
  has_many :relationships, class_name: "Relationship", foreign_key: "follow_id", dependent: :destroy
  has_many :reverse_relationships, class_name: "Relationship", foreign_key: "follower_id", dependent: :destroy

  # viewで表示するとき
  has_many :follows, through: :relationships, source: :follower
  has_many :followers, through: :reverse_relationships, source: :follow

  # フォローの際のメソッド
  # フォローしたとき
  def follow(user_id)
    relationships.create(follower_id: user_id)
  end
  # フォローを外すとき
  def unfollow(user_id)
    relationships.find_by(follower_id: user_id).destroy
  end
  # フォロー判別
  def following?(user)
    follows.include?(user)
  end

  # 通知機能の記述
  # 自分からの通知
  has_many :from_me_notifications, class_name: "Notification", foreign_key: "from_user_id", dependent: :destroy
  # 相手からの通知
  has_many :to_me_notifications, class_name: "Notification", foreign_key: "to_user_id", dependent: :destroy

  # フォロー通知用のメソッド
  def notification_follow!(current_user)
    temp = Notification.where(["from_user_id = ? and to_user_id = ? and action = ? ",current_user.id, id, 'follow'])
    if temp.blank?
      notification = current_user.from_me_notifications.new(
        to_user_id: id,
        action: 'follow'
      )
      notification.save if notification.valid?
    end
  end
  
  # ↓omniauthのコールバック時に呼ばれるメソッド
  def self.from_omniauth(auth)
    where(provider: auth.provider, uid: auth.uid).first_or_create do |user|
      user.name = auth.info.name
      user.email = auth.info.email
      user.password = Devise.friendly_token[0,20]
    end
  end

end
