class CreateRosettaTables < ActiveRecord::Migration
  def up
    create_table :phrases do |t|
      t.string :key, :unique => true, :null => false
    end

    create_table :translations do |t|
      t.integer :phrase_id, :null => false
      t.string  :locale, :null => false
      t.text    :text
    end

    add_index :phrases, :key, :unique => true
    add_index :translations, :phrase_id
    add_index :translations, :locale
  end

  def down
    drop_table :phrases
    drop_table :translations
  end
end
