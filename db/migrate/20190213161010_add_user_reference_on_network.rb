class AddUserReferenceOnNetwork < ActiveRecord::Migration[5.2]
  def change
    add_reference :network, :user, index: true, foreign_key: true
  end
end
