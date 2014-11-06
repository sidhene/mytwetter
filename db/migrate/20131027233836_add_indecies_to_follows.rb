class AddIndeciesToFollows < ActiveRecord::Migration
  def change
    add_index :follows, [:user_id, :following_id]
  end
end
