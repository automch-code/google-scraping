active_admin = User.new(
  email: 'admin@example.com',
  password: 'password',
  password_confirmation: 'password',
  role: User.roles[:admin]
)
active_admin.skip_confirmation!

active_user = User.new(
  email: 'user@example.com',
  password: 'password',
  password_confirmation: 'password',
  role: User.roles[:user]
)
active_user.skip_confirmation!


[active_admin, active_user].each do |user|
  user.save!
end
