class CreateReviews < ActiveRecord::Migration[6.1]
  def change
    create_table :reviews do |t|
      t.belongs_to :user
      t.belongs_to :problem

      t.integer :attempts, limit: 2, default: 0
      t.integer :repetitions, limit: 2, default: 0
      t.integer :interval, limit: 2, default: 0
      t.decimal :factor, precision: 3, scale: 2, default: 2.5
      t.datetime :due

      t.timestamps
    end
  end
end
