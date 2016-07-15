# This is the primary location for defining spree preferences
#
# The expectation is that this is created once and stored in
# the spree environment
#
# setters:
# a.color = :blue
# a[:color] = :blue
# a.set :color = :blue
# a.preferred_color = :blue
#
# getters:
# a.color
# a[:color]
# a.get :color
# a.preferred_color
#
Spree::AppConfiguration.class_eval do
  # Preferences related to banner settings
  preference :banner_default_url, :string, :default => '/spree/banners/:id/:style/:basename.:extension'
  preference :banner_path, :string, :default => ':rails_root/public/spree/banners/:id/:style/:basename.:extension'
  preference :banner_url, :string, :default => '/spree/banners/:id/:style/:basename.:extension'
  preference :banner_styles, :string, :default => "{\"mini\":\"192x64#\",\"default\":\"1000x325>\",\"logo\":\"250x71#\",\"minibanner\":\"269x196#\"}"
  preference :banner_default_style, :string, :default => 'small'
end
