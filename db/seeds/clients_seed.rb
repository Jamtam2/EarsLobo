# require 'faker'

# 10.times do
#   Client.create!(
#     first_name: Faker::Name.first_name,
#     last_name: Faker::Name.last_name,
#     email: Faker::Internet.email,
#     date_of_birth: Faker::Date.birthday(min_age: 18, max_age: 65),
#     mgmt_ref: Faker::Number.hexadecimal(digits: 10),
#     gender: ['Male', 'Female', 'Other'].sample,
#     address1: Faker::Address.street_address,
#     country: Faker::Address.country,
#     state: Faker::Address.state,
#     city: Faker::Address.city,
#     zip: Faker::Address.zip_code,
#     phone1: Faker::Number.leading_zero_number(digits: 10),
#     phone2: Faker::Number.leading_zero_number(digits: 10)
#   )do |client|
#     2.times do
#       client.emergency_contacts.build(
#         first_name: Faker::Name.first_name,
#         last_name: Faker::Name.last_name,
#         phone_number: Faker::Number.leading_zero_number(digits: 10),
#         address: Faker::Address.street_address,
#         email: Faker::Internet.email,
#         city: Faker::Address.city,
#         state: Faker::Address.state,
#       )
#     end
#     client.save!
#   end

# end
