# config/initializers/cors.rb

Rails.application.config.middleware.insert_before 0, Rack::Cors do
  allow do
    origins 'https://epm4-edufss14.b4a.run'

    resource '/users/sign_in',
      headers: ['Origin', 'Accept', 'Content-Type'],
      methods: [:post],
      credentials: true,
      max_age: 3600

    resource '/users/sign_up',
      headers: ['Origin', 'Accept', 'Content-Type'],
      methods: [:post],
      credentials: true,
      max_age: 3600

    resource '/users/sign_out',
      headers: ['Origin', 'Accept', 'Content-Type'],
      methods: [:delete],
      credentials: true,
      max_age: 3600

    resource '/admins/sign_in',
      headers: ['Origin', 'Accept', 'Content-Type'],
      methods: [:post],
      credentials: true,
      max_age: 3600

    resource '/admins/sign_up',
      headers: ['Origin', 'Accept', 'Content-Type'],
      methods: [:post],
      credentials: true,
      max_age: 3600

    resource '/admins/sign_out',
      headers: ['Origin', 'Accept', 'Content-Type'],
      methods: [:delete],
      credentials: true,
      max_age: 3600
  end
end
