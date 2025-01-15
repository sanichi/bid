import "jquery"
import "popper"
import "bootstrap"
import "@hotwired/turbo-rails"
import "controllers"

// Start Turbo disabled until we explcitly opt-in (with data-turbo => true on some element).
Turbo.session.drive = false

