class AddUserIdToScrapingTasks < ActiveRecord::Migration[8.1]
  def change
    add_column :scraping_tasks, :user_id, :integer
  end
end
