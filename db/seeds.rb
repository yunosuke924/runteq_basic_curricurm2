User.create!(first_name: 'Sakamoto',
             last_name: 'Ryoma',
             email: 'ryoma@mail.com',
             password: 'foobar',
             password_confirmation: 'foobar',
             created_at: Time.now,
             updated_at: Time.now)

20.times do |n|

    title = Faker::Games::Pokemon.name
    body = Faker::Games::Pokemon.move
    user = User.find_by(email: 'ryoma@mail.com')

    
    Board.create!(title: title, 
                    body: body,
                    user_id: user.id,
                    created_at: Time.now,
                    updated_at: Time.now)
                    
end