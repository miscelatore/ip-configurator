class AddUserReferenceOnAssignedAddress < ActiveRecord::Migration[5.2]
  def change
    add_reference :assigned_address, :user, index: true, foreign_key: true
  end
end
