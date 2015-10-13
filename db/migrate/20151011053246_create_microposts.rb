class CreateMicroposts < ActiveRecord::Migration
  def change
    create_table :microposts do |t|
      t.text :content
      # sqlite3 does not support foreign_key but for what we are doing the production environment uses postgresql which supports it.
      # t.reference => t.string :user_id
      t.references :user, index: true, foreign_key: true

      t.timestamps null: false
    end
    # adds index on user_id and created_at columns since we expect to reverse the order of the microposts with a given user_id
    # By including both the user_id and created_at columns as an array,
    # we arrange for Rails to create a multiple key index,
    # which means that Active Record uses both keys at the same time.
    add_index :microposts, [:user_id, :created_at]
  end
end
