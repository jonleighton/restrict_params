module RestrictParams
  module ControllerExtensions
    def self.included(base)
      base.send :extend, ClassMethods
      base.send :before_filter, :delete_restricted_params
    end
    
    module ClassMethods
      def restrict_params(opts)
        param_restrictions << Restriction.new(opts)
      end
      
      def param_restrictions
        @param_restrictions ||= []
      end
    end
    
    def delete_restricted_params
      self.class.param_restrictions.each { |item| item.apply(self) }
    end
  end
end
