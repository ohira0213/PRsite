class CreateRequests < ActiveRecord::Migration[6.1]
  def change
    create_table :requests do |t|
      t.integer :user_id
      t.string :mark_status, default: :unverified
      t.boolean :mark
      t.timestamps
    end
  end
end
