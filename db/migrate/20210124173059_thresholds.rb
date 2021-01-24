class Thresholds < ActiveRecord::Migration[6.0]
  def change
    create_table :thresholds do |t|
      t.bigint :user_id
      t.decimal :lower, precision: 12, scale: 5
      t.decimal :upper, precision: 12, scale: 5
      t.datetime :notified_at, default: nil

      t.timestamps
    end

    add_foreign_key :thresholds, :users

    add_index :thresholds, :lower
    add_index :thresholds, :upper
  end
end
