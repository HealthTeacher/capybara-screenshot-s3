module Capybara
  module Screenshot
    module S3

      module_function

      def module_exists?(name, base = self.class)
        base.const_defined?(name) &&
        base.const_get(name).instance_of?(::Module)
      end
    end
  end
end
