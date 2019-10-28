50.times do |n|
  name = Faker::Games::Fallout.character
  email = Faker::Internet.email
  password = "password"
  User.create!(name: name,
               email: email,
               password: password,
               password_digest: password,
               )
end
