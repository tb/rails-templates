
lib_name = "jquery.fancybox-1.3.3"

download_path = "http://fancybox.googlecode.com/files/#{lib_name}.zip"
app_tmp_path = File.expand_path('tmp/fancybox', Rails.root)
zip_file = "#{app_tmp_path}/#{lib_name}.zip"

run "rm -rf #{app_tmp_path}", :verbose => false
get download_path, zip_file
run "unzip #{zip_file} -d #{app_tmp_path}", :verbose => false

js_files = []

inside Rails.root do
  # images
  run "mkdir -p public/images/fancybox"
  run "cp #{app_tmp_path}/#{lib_name}/fancybox/{*.png,*.gif} public/images/fancybox"

  # css
  css = File.read("#{app_tmp_path}/#{lib_name}/fancybox/#{lib_name}.css")
  css.gsub!(/url\(\'/, "url('/images/fancybox/")
  css.gsub!(/\'fancybox\//, "/images/fancybox/")
  file "public/stylesheets/fancybox.css", css

  # js
  run "mkdir -p public/javascripts/fancybox"
  run "cp #{app_tmp_path}/#{lib_name}/fancybox/*.js public/javascripts/fancybox"
 
  # initializer
  Dir.glob("public/javascripts/fancybox/*.pack.js").each do |js_file|
    js_files << File.basename(js_file)
  end
  js_files_str = js_files.map { |file| "'fancybox/#{file}'" }.join(',')
  initializer 'fancybox.rb', "ActionView::Helpers::AssetTagHelper.register_javascript_expansion :fancybox => [#{js_files_str}]"
end

#run "rm -rf #{app_tmp_path}", :verbose => false

puts <<EOT
========================================================================

Add in application layout:

	<%= stylesheet_link_tag 'fancybox' %>
	<%= javascript_include_tag :fancybox %>

========================================================================
EOT

