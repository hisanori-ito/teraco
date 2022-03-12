class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable
         
  has_many :posts, dependent: :destroy
  has_many :comments, dependent: :destroy
  has_many :favorites, dependent: :destroy
  
  # フォロー機能の記述
  # フォローを行うとき
  has_many :relationships, class_name: "Relationship", foreign_key: "follow_id", dependent: :destroy
  has_many :reverse_relationships, class_name: "Relationship", foreign_key: "follower_id", dependent: :destroy
  
  # viewで表示するとき
  has_many :follows, through: :relationships, source: :follow
  has_many :followers, through: :reverse_relationships, source: :follower
  
  # フォローの際のメソッド
  # フォローしたとき
  def follow(user_id)
    relationships.create(follow_id: user_id)
  end
  # フォローを外すとき
  def unfollow(user_id)
    relationships.find_by(followed_id: user_id).destroy
  end
  # フォロー判別
  def follow_by?(user)
    follows.include?(user)
  end
  
end
