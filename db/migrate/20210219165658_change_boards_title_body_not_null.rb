class ChangeBoardsTitleBodyNotNull < ActiveRecord::Migration[5.2]
  def change
    change_column_null :boards, :title, false
    change_column_null :boards, :body, false
  end
end
