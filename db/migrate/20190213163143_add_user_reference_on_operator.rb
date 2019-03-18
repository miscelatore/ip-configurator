class AddUserReferenceOnOperator < ActiveRecord::Migration[5.2]
  def change
    add_reference :operator, :user, index: true, foreign_key: true
  end
end
