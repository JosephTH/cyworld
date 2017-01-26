class AddPostNumToPosts < ActiveRecord::Migration
  def change
    add_column :posts, :post_num, :integer
  end
end
