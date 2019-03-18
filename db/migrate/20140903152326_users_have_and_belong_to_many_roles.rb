class UsersHaveAndBelongToManyRoles < ActiveRecord::Migration[4.2]
  def change
    create_table :roles_users , id: false do | t | 
          t. references :role , :user 
    end
  end
end
