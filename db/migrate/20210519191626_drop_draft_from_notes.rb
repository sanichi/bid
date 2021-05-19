class DropDraftFromNotes < ActiveRecord::Migration[6.1]
  def change
    remove_column :notes, :draft, :boolean, default: true
  end
end
