%w[create_oauth_application create_user].each do |filename|
  puts
  start = Time.now
  p "***************** #{filename.humanize} *****************"
  require Rails.root.join('db', 'seeds', "#{Rails.env}/#{filename}.rb")
  p "----------------- Finished in #{Time.now - start} seconds -----------------"
end