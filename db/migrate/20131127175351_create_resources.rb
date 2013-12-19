class CreateResources < ActiveRecord::Migration
  def change
    create_table :resources do |t|
      t.string :name
      t.string :preview
      t.string :type
      t.text :description
      t.has_attached_file :picture
      t.text :details
      t.timestamps
    end
    
    create_table :owners_possessions, id: false do |t|
      t.integer :owner_id
      t.integer :possession_id
    end
    
  end
end