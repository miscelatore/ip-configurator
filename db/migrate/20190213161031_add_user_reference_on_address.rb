class AddUserReferenceOnAddress < ActiveRecord::Migration[5.2]
  def change
    add_reference :address, :user, index: true, foreign_key: true
  end
end
