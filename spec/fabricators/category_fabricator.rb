Fabricator(:category) do
  name 'Comedies'
  videos(count: 7) { Fabricate.build(:video, category: nil) }
end