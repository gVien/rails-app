class CreateRelationships < ActiveRecord::Migration
  def change
    create_table :relationships do |t|
      t.integer :follower_id
      t.integer :followed_id

      t.timestamps null: false
    end
    # add index to speed up search in relationship for followed and follower
    add_index :relationships, :followed_id
    add_index :relationships, :follower_id
    # the true in uniqueness means the table cannot have [1, 1], [1, 1], [3, 3], [3, 3] etc
    # this means the same user cannot follow the other user twice in the table
    # the user interface will prevent this from happening but
    # adding it in the model side to raise an error, in case if this is modified from a command line tool (e.g. curl)
    add_index :relationships, [:followed_id, :follower_id], unique: true
  end
end
