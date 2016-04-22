class DeleteCommentColumn < ActiveRecord::Migration
  def change
    remove_column :events, :comment
  end
end
