class AddTitleToScrapingTasks < ActiveRecord::Migration[8.1]
  def change
    add_column :scraping_tasks, :title, :string
  end
end
