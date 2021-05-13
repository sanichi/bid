class AddCategoryToProblems < ActiveRecord::Migration[6.1]
  def change
    add_column :problems, :category, :string, limit: 50
  end
end
