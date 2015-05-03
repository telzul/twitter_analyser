# Be sure to restart your server when you modify this file.

# Version of your assets, change this if you want to expire all your assets.
Rails.application.config.assets.version = '1.0'

# Precompile additional assets.
# application.js.coffee, application.css.scss, and all non-JS/CSS in app/assets folder are already added.
# Rails.application.config.assets.precompile += %w( search.js )

Rails.application.config.assets.precompile += %w( d3.min.js )
Rails.application.config.assets.precompile += %w( chart.js )
Rails.application.config.assets.precompile += %w( tree.js )

Rails.application.config.assets.precompile += %w( tree.css )
