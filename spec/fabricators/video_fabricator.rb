Fabricator(:video) do
  title { Faker::Commerce.product_name }
  description { Faker::Lorem.paragraph }
  category
end