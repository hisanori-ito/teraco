class RemoveImpressionsCountFromPosts < ActiveRecord::Migration[6.1]
  def change
    remove_column :posts, :impressions_count, :integer
  end
end
