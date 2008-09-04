module RestrictParams
  class Restriction
    attr_reader :controller, :opts
    
    def initialize(opts)
      raise ArgumentError, "You have to specify the :to option" unless opts[:to]
      @opts = opts
    end
    
    def apply(controller)
      @controller = controller
      
      if params && applies_to_current_action? && condition_satisfied?
        restricted_keys.each { |key| params.delete(key) }
      end
    end
    
    private
    
      def applies_to_current_action?
        if opts[:only]
          Array(opts[:only]).map(&:to_s).include?(controller.action_name)
        else
          true
        end
      end
      
      def condition_satisfied?
        if opts[:if]
          controller.send(:instance_eval, opts[:if].to_s) == true
        elsif opts[:unless]
          controller.send(:instance_eval, opts[:unless].to_s) != true
        else
          true
        end
      end
      
      def params
        controller.params[resource_name]
      end
      
      def resource_name
        controller.controller_name.singularize
      end
      
      def restricted_keys
        params.keys - opts[:to].map(&:to_s)
      end
  end
end
