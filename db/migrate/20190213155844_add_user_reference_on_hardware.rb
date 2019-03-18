class AddUserReferenceOnHardware < ActiveRecord::Migration[5.2]
  def change
    add_reference :hardware, :user, index: true, foreign_key: true
  end
end
