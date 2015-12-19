# Be sure to restart your server when you modify this file.

# Version of your assets, change this if you want to expire all your assets.
Rails.application.config.assets.version = '1.0'

# Add additional assets to the asset load path
# Rails.application.config.assets.paths << Emoji.images_path

# Precompile additional assets.
# application.js, application.css, and all non-JS/CSS in app/assets folder are already added.
# Rails.application.config.assets.precompile += %w( search.js )

# for Bootstrap fonts 
# refer to: http://gascar-shunt.tumblr.com/post/65236279971/rails-4%E3%81%A7bootstrap-3-glyphicon%E5%95%8F%E9%A1%8C%E3%82%82%E8%A7%A3%E6%B1%BA
config.assets.precompile +=  %w( *.woff *.eot *.svg *.ttf )
