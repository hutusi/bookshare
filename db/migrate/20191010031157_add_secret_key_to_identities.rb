class AddSecretKeyToIdentities < ActiveRecord::Migration[6.0]
  def change
    add_column :identities, :secret_key, :string
  end
end
