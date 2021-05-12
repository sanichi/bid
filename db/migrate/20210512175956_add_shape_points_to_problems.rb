class AddShapePointsToProblems < ActiveRecord::Migration[6.1]
  def change
    add_column :problems, :shape, :string, limit: 10
    add_column :problems, :points, :integer, limit: 1
  end
end
