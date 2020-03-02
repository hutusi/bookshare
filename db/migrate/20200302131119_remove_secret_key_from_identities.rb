class RemoveSecretKeyFromIdentities < ActiveRecord::Migration[6.0]
  def change
    remove_column :identities, :secret_key
  end
end
