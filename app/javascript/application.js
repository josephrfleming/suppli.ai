import { application } from "./controllers/application" // Bootstraps Stimulus

// Import custom controllers
import RangeController from "./controllers/range_controller"
import LoadingController from "./controllers/loading_controller"

// Register controllers
application.register("range", RangeController)
application.register("loading", LoadingController)
