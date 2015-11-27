class AddArchivedToEntries < ActiveRecord::Migration
  def change
    add_column :entries, :archived, :boolean, default: false
  end
end
