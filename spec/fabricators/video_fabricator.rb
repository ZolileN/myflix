Fabricator(:video) do
  title { Faker::Lorem.sentence }
  description { Faker::Lorem.paragraph }
  categories { [Fabricate(:category)] }
end