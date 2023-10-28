if Doorkeeper::Application.count.zero?
  app = Doorkeeper::Application.create!(
    name: 'Application',
    redirect_uri: "urn:ietf:wg:oauth:2.0:oob",
    scopes: ["read", "write"],
    uid: ENV['CLIENT_ID'],
    secret: ENV['CLIENT_SECRET']
  )

  puts "Client id: #{app.uid}"
  puts "Client secret: #{app.secret}"
end