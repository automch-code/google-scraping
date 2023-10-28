active_admin = User.new(
  email: 'admin@example.com',
  password: 'password',
  password_confirmation: 'password',
  role: User.roles[:admin]
)
active_admin.skip_confirmation!


[active_admin].each do |user|
  user.save!
end
