
# Why do we need controller_observer when we already can observe ActiveRecord modles?

Imagine you have a tree structure where any node can hav multiple subnodes of the same type. When you delete one of the node, its children will also be deleted. If you observe the ActiveRecord model you will get an *after_destroy* for each subnode too.

With *controller_observer* we can observe the delete method of the API and only get one *after_destroy* when a complete subtree will be deleted.

# Usage

To observe the _destroy_ action of the NodesController, just create a new file *app/controllers/nodes_controller_observer.rb*

	class NodesControllerObserver < ControllerObserver::Observer
	  def after_destroy(node)
	    # do something, node contains the deleted node
	    # this function will only be called if the request was successfull
	  end
	end
	
and add the following to your *config/application.rb*

	config.to_prepare do
	  ActionController::Base.observers = :nodes_controller_observer
	  ActionController::Base.instantiate_observers
	end


