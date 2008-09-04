require File.dirname(__FILE__) + "/spec_helper"

module RestrictParams
  describe "ControllerExtensions" do
    before do
      @klass = Class.new
      @klass.stubs(:before_filter).with(:delete_restricted_params)
    end
  
    it "should extend with the ClassMethods when included in a class" do
      @klass.expects(:extend).with(ControllerExtensions::ClassMethods)
      @klass.send :include, ControllerExtensions
    end
  
    it "should add the before filter when included in a class" do
      @klass.expects(:before_filter).with(:delete_restricted_params)
      @klass.send :include, ControllerExtensions
    end
  end
  
  describe "A controller class with the ControllerExtensions included" do
    before do
      @klass = Class.new
      @klass.stubs(:before_filter)
      @klass.send :include, ControllerExtensions
    end
    
    it "should create a new Restriction when asked to restrict params" do
      Restriction.expects(:new).with(opts = stub)
      @klass.restrict_params(opts)
    end
    
    it "should store restrictions in a param_restrictions attribute" do
      restriction = stub_everything
      Restriction.expects(:new).returns(restriction)
      @klass.restrict_params(:to => [:whatever])
      @klass.param_restrictions.should include(restriction)
    end
  end
  
  describe "An instantiated controller which has multiple restrictions" do
    before do
      @klass = Class.new
      @klass.stubs(:before_filter)
      @klass.send :include, ControllerExtensions
      3.times { @klass.restrict_params(:to => [:whatever]) }
      @controller = @klass.new
    end
    
    it "should apply all the restrictions to the controller when asked to delete restricted params" do
      @klass.param_restrictions.each { |r| r.expects(:apply).with(@controller) }
      @controller.delete_restricted_params
    end
  end
end
