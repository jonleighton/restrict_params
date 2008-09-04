require File.dirname(__FILE__) + "/lib/restrict_params"
ActionController::Base.send :include, RestrictParams::ControllerExtensions
