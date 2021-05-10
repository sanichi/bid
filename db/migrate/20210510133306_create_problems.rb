class CreateProblems < ActiveRecord::Migration[6.1]
  def change
    create_table   :problems do |t|
      t.string     :bids
      t.string     :hand, limit: 16
      t.string     :vul, limit: 4
      t.text       :note
      t.boolean    :draft, default: true
      t.belongs_to :user

      t.timestamps
    end
  end
end
