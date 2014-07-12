Fabricator(:user) do
  full_name { "#{Faker::Name.first_name} #{Faker::Name.last_name}"}
  email { |attrs| "#{Faker::Internet.free_email(attrs[:full_name].parameterize)}" }
  password '1111'
  admin false
end

Fabricator(:admin, from: :user) do
  admin true
end