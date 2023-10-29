def fixture_file_path(filename)
  Rails.root.join("spec/fixtures/#{filename}").to_s
end