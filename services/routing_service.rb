# TODO: Refactor along the lines of http://brewhouse.io/blog/2014/04/30/gourmet-service-objects.html
# I like the approach much better. 
# * Services start with a verb (and do not end with Service). Why put the pattern name in?
# ** Should be renamed to FetchRoutesForSpecification 
# Use a `call` method (the de facto Ruby method for lambda, procs and method objects) such as def self.call(r_s)
#
class RoutingService
  def fetch_routes_for_specification(route_specification)
    routes = Array.new
    routes
  end
end