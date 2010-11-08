
download_path = "http://colorpowered.com/colorbox/colorbox.zip"
app_tmp_path = File.expand_path('tmp/colorbox', Rails.root)
zip_file = "#{app_tmp_path}/colorbox.zip"

run "rm -rf #{app_tmp_path}", :verbose => false
get download_path, zip_file
run "unzip #{zip_file} -d #{app_tmp_path}", :verbose => false

inside Rails.root do
  # iamges/
  run "cp -R #{app_tmp_path}/colorbox/example4/images public/images/colorbox"

  # css
  css = File.read("#{app_tmp_path}/colorbox/example4/colorbox.css")
  css.gsub!(/images\//, '/images/colorbox/')
  file "public/stylesheets/colorbox.css", css

  # js
  Dir.glob("#{app_tmp_path}/colorbox/colorbox/jquery.*-min.js").each do |js_file|
    copy_file js_file, 'public/javascripts/jquery.colorbox.js'
  end
end

run "rm -rf #{app_tmp_path}", :verbose => false

puts <<EOT
========================================================================

Add in application layout:

	<%= stylesheet_link_tag 'colorbox' %>
	<%= javascript_include_tag 'jquery.colorbox' %>

========================================================================
EOT

