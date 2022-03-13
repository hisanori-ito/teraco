class Notification < ApplicationRecord
    
  default_scope -> { order(created_at: :desc) }
  belongs_to :post, optional: true
  belongs_to :comment, optional: true

  belongs_to :from_user, class_name: 'User', foreign_key: 'from_user_id', optional: true
  belongs_to :to_user, class_name: 'User', foreign_key: 'to_user_id', optional: true

end
