ProfileInfo.find_or_create_by!(id: 1) do |profile|
  profile.about_me = "Transforming raw footage into cinematic experiences through precision editing."
  profile.years_experience = "5+"
  profile.client_satisfaction = "100%"
  profile.projects_completed = "50+"
end

puts "Profile Info seeded."

# Creates the first admin account from Render/Netlify environment variables.
# Set ADMIN_EMAIL and ADMIN_PASSWORD in your hosting dashboard.
admin_email = ENV["ADMIN_EMAIL"].presence
admin_password = ENV["ADMIN_PASSWORD"].presence

if admin_email && admin_password
  admin = Admin.find_or_initialize_by(email: admin_email)

  if admin.new_record? || ENV["ADMIN_RESET_PASSWORD"] == "true"
    admin.password = admin_password
    admin.password_confirmation = admin_password
    admin.save!
    puts "Admin account #{admin_email} is ready."
  else
    puts "Admin account #{admin_email} already exists (password unchanged)."
  end
end
