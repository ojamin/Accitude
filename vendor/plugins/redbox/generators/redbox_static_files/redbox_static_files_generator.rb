class RedboxStaticFilesGenerator < Rails::Generator::Base
  def manifest
    record do |m|
      m.file "redbox.css", "public/stylesheets/redbox.css"
      m.file "redbox.js", "public/javascripts/redbox.js"
      m.file "redbox_spinner.gif", "public/images/redbox_spinner.gif"
    end
  end
end