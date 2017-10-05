Picguard.configure do |config|
  config.google_api_key = 'AIzaSyCjwobVdct9CTIb99h1YgECAU5cv425hrk'
  config.threshold_adult = "POSSIBLE"
  config.threshold_violence = "LIKELY"
  config.threshold_face = 0.8
end
