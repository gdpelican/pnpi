class CreateTags < ActiveRecord::Migration
  def change
    create_table :tags do |t|
      t.string :tag
      t.string :resource
      t.string :category
    end
    
    create_table :resources_tags, id: false do |t|
      t.references :tag
      t.references :resource
    end
    
    add_index :resources_tags, :tag_id
    add_index :resources_tags, :resource_id
    
  end
end
