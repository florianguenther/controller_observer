require 'singleton'

module ControllerObserver
	module ClassMethods
		def observers=(*observers)
			@observers = observers.flatten
		end

		# Gets the current observers.
		def observers
			@observers ||= []
		end

		# Instantiate the global Active Controller observers.
		def instantiate_observers
			return if @observers.blank?
			@observers.each do |observer|
			  if observer.respond_to?(:to_sym) # Symbol or String
					observer.to_s.camelize.constantize.instance
			  #elsif observer.respond_to?(:instance)
					# observer.instance
					# puts "instance: #{observer}"
			  else
					raise ArgumentError, "#{observer} must be a lowercase, underscored class name (or an instance of the class itself) responding to the instance method. Example: Person.observers = :big_brother # calls BigBrother.instance"
			  end
			end
		end
	end

	class Observer
		include Singleton

		class << self
			def observed_class
				if observed_class_name = name[/(.*)Observer/, 1]
				  observed_class_name.constantize
				else
				  nil
				end
			end
		end

		def initialize
			add_observer!(self.class.observed_class)
		end
		
		def before(controller)

		end
		
		def after(controller)			
			method = get_method(controller)
			if respond_to?(method) && response([200, 201], controller)
				send(method, get_item(controller))
			end
			return true
		end	

		def get_method(controller)
			"after_#{controller.action_name}".to_sym
		end
		
		def get_item(controller)
			var_sym = "@#{controller.controller_name.singularize}".to_sym
			return controller.instance_variable_get(var_sym) if controller.instance_variable_defined?(var_sym)
			nil
		end

		def response(code_expected, controller)
			@status = controller.response.status.to_s.match(/([0-9]*)/)[0].to_i
			code_expected.include? @status
		end

		protected 
		def add_observer!(klass)
			klass.after_filter self
		end

	end
end

unless ActionController::Base.respond_to?(:observers)
	ActionController::Base.send(:extend, ControllerObserver::ClassMethods)
	# ActionController::Dispatcher.to_prepare(:actioncontroller_instantiate_observers) { ActionController::Base.instantiate_observers }
end