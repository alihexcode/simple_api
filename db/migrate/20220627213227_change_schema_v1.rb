class ChangeSchemaV1 < ActiveRecord::Migration[6.0]
  def change
    create_table :users do |t|
      t.string :encrypted_password, default: '', null: false
      t.string :email, null: false
      t.string :reset_password_token
      t.datetime :reset_password_sent_at
      t.datetime :remember_created_at
      t.datetime :current_sign_in_at
      t.datetime :last_sign_in_at
      t.string :current_sign_in_ip
      t.string :last_sign_in_ip
      t.integer :sign_in_count, default: 0, null: false
      t.timestamps null: false
    end

    create_table :recipes do |t|
      t.string :title, null: false
      t.text :descriptions, null: false
      t.string :time, null: false
      t.integer :difficulty, null: false
      t.timestamps null: false
    end

    create_table :ingredients do |t|
      t.integer :unit, default: 0, null: false
      t.float :amount, null: false
      t.timestamps null: false
    end

    create_table :categories do |t|
      t.text :description
      t.timestamps null: false
    end

    add_reference :recipes, :user, foreign_key: true
    add_reference :ingredients, :recipe, foreign_key: true
    add_reference :recipes, :category, foreign_key: true

    add_index :users, :email, unique: true
    add_index :users, :reset_password_token, unique: true
  end
end
