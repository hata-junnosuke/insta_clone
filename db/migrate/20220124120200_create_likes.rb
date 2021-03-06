class CreateLikes < ActiveRecord::Migration[5.2]
  def change
    create_table :likes do |t|
      t.references :user, foreign_key: true
      t.references :post, foreign_key: true

      t.timestamps
      # これでこのuser_idとpost_idの組み合わせのダブりを防ぐ
      t.index [:user_id, :post_id], unique: true
    end
  end
end
