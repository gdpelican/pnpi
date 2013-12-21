class CreateTags < ActiveRecord::Migration
  def change
    
    create_table :tags do |t|
      t.belongs_to :tag_type
      t.string :tag
    end
    
    create_table :tag_types do |t|
      t.string :name
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
