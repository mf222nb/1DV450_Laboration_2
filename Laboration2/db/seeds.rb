# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)

User.create!(name: "admin@admin.com",
             password:              "password",
             password_confirmation: "password",
             admin: true)

Creator.create!(name: "Steve",
                password: "qwerty",
                password_confirmation: "qwerty")

Creator.create!(name: "Jonas",
                password: "qwerty",
                password_confirmation: "qwerty")

Creator.create!(name: "Pelle",
                password: "qwerty",
                password_confirmation: "qwerty")

Key.create!(user_id: 1,
            key: "12345")

Position.create!(long: 16.357819,
                 lat: 56.679659)

Tag.create!(name: "sport")

Event.create!(tags: Tag.all,
              creator_id: 1,
              position_id: 1,
              description: "Tennistävling",
              title: "Tennis")
