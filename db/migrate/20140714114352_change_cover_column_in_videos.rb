class ChangeCoverColumnInVideos < ActiveRecord::Migration
  change_table :videos do |t|
    t.rename :small_cover_url, :small_cover
    t.rename :large_cover_url, :large_cover
  end
end
