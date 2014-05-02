Pod::Spec.new do |s|
  s.name         = "CueTableViewDataSource"
  s.version      = "1.0.0"
  s.summary      = "Adapter abstraction for UITableViews"
  s.homepage     = "https://github.com/asarazan/CueTableViewDataSource"
  s.license      = 'Apache'
  s.authors      = { "Aaron Sarazan" => "aaron@sarazan.net" }
  s.source       = { :git => "https://github.com/sarazan/CueTableViewDataSource.git" }
  s.source_files = "Classes/**"
  s.platform     = :ios, '5.0'
  s.requires_arc = true
end
