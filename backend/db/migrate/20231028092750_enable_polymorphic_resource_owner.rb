class EnablePolymorphicResourceOwner < ActiveRecord::Migration[7.0]
  def change
    add_column :oauth_access_tokens, :resource_owner_type, :string

    add_index :oauth_access_tokens,
              [:resource_owner_id, :resource_owner_type],
              name: 'polymorphic_owner_oauth_access_tokens'
  end
end
