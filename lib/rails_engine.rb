# encoding: UTF-8

module QA_Rails

  class Engine < Rails::Engine
    initializer "qa.load_app_instance_data" do |app|
      app.class.configure do
        ['db/migrate', 'app/assets', 'app/models', 'app/controllers', 'app/views'].each do |path|
          config.paths[path] ||= []
          config.paths[path] += QA_Rails::Engine.paths[path].existent
        end
      end
    end
  end

end
