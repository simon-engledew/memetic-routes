ActionController::Routing::RouteSet::NamedRouteCollection.class_eval do
  alias_method_chain(:define_hash_access, :memetic_routes) do
    define_method(:define_hash_access_with_memetic_routes) do |route, name, kind, options|
      returning(define_hash_access_without_memetic_routes(route, name, kind, options)) do
        
        if remember = route.instance_variable_get(:@requirements)[MemeticRoutes::KEYWORD] then
          selector = hash_access_name(name, kind)
          @module.module_eval do
            alias_method_chain(selector, :memetic_routes) do
              define_method(:"#{selector}_with_memetic_routes") do |options|
                options ||= {}
                options[remember] = params[remember]
                send(:"#{selector}_without_memetic_routes", options)
              end
            end
          end
        end
        
      end
    end
  end
end