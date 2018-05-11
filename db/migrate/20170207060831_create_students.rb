class CreateStudents < ActiveRecord::Migration
  def change
    create_table :students do |t|
      t.string :title
      t.integer :post_num

      t.timestamps null: false
    end
  end
end
