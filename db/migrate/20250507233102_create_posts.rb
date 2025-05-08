class CreatePosts < ActiveRecord::Migration[7.2]
  def change
    create_table :posts do |t|
      t.string :title
      t.text :content
      t.text :description
      t.boolean :published
      t.boolean :premium
      t.references :user, null: false, foreign_key: true
      t.string :slug

      t.timestamps
    end
  end
end
