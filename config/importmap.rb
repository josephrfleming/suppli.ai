# config/importmap.rb

# Core application entrypoint
pin "application"

# Hotwired Stimulus
pin "@hotwired/stimulus", to: "stimulus.min.js"
pin "@hotwired/stimulus-loading", to: "stimulus-loading.js"

# Load all controllers automatically from app/javascript/controllers
pin_all_from "app/javascript/controllers", under: "controllers"

# Optional: Hotwired Turbo (uncomment if you use it)
# pin "@hotwired/turbo-rails", to: "turbo.min.js"
