class DropDraftFromProblems < ActiveRecord::Migration[6.1]
  def change
    remove_column :problems, :draft, :boolean, default: true
  end
end
