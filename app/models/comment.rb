class Comment < ApplicationRecord
  belongs_to :user
  belongs_to :post

  after_save :update_comments_counter

  def update_comments_counter
    post = Post.find(post_id)
    post.update(comments_counter: post.comments.count)
  end
end
