require 'moar'
require 'rails'

module ActiveRecordMock
  class Railtie < Rails::Railtie
    railtie_name :moar

    rake_tasks do
      load "tasks/moar.rake"
    end
  end
end
