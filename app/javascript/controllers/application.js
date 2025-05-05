import { Application } from "@hotwired/stimulus"

const application = Application.start()

// Configure Stimulus 
application.debug = false
window.Stimulus   = application

export { application }
