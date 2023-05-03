class Post < ApplicationRecord
  belongs_to :user, foreign_key: :author_id

  has_many :comments
  has_many :likes

  validates :title, presence: true, length: { maximum: 250 }
  validates :comments_counter, numericality: { greater_than_or_equal_to: 0 }
  validates :likes_counter, numericality: { greater_than_or_equal_to: 0 }

  before_save :set_defaults
  after_save :update_posts_counter

  def set_defaults
    self.comments_counter ||= 0
    self.likes_counter ||= 0
  end

  def recent_comments
    Comment.where(post_id: id).order(created_at: :desc).limit(3)
  end

  def update_posts_counter
    user = User.find(author_id)
    user.update(posts_counter: user.posts.count)
  end
end
