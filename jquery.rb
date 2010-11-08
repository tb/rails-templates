
inside('public/javascripts') do
  FileUtils.rm_rf %w(controls.js dragdrop.js effects.js prototype.js rails.js)
end

inside Rails.root do
  get "http://code.jquery.com/jquery-latest.min.js", "public/javascripts/jquery.js"
  run "wget https://github.com/rails/jquery-ujs/raw/master/src/rails.js --no-check-certificate -O public/javascripts/rails.js", :verbose => false
end

jquery_rb_file = ""

if yes?("Register as javascript expansion :defaults ?")
  jquery_rb_file << <<CODE
ActiveSupport.on_load(:action_view) do
  ActiveSupport.on_load(:after_initialize) do
    ActionView::Helpers::AssetTagHelper::register_javascript_expansion :defaults => ['jquery', 'rails']
  end
end
CODE
end

if yes?("Register as javascript expansion :jquery ?")
  jquery_rb_file << <<CODE

ActionView::Helpers::AssetTagHelper.register_javascript_expansion :jquery => ['jquery', 'rails']
CODE
end

initializer 'jquery.rb', jquery_rb_file
