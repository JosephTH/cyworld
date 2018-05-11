class CreateCurrencies < ActiveRecord::Migration
  def change
    create_table :currencies do |t|
      t.float :euro

      t.timestamps null: false
    end
  end
end
