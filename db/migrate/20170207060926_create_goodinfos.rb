class CreateGoodinfos < ActiveRecord::Migration
  def change
    create_table :goodinfos do |t|
      t.string :title
      t.integer :post_num

      t.timestamps null: false
    end
  end
end
