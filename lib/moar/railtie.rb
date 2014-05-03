require 'moar'
require 'rails'
require 'moar/model_builder'

module Moar
  class Railtie < Rails::Railtie
    railtie_name :moar

    rake_tasks do
      namespace :moar do
        desc 'Initiates a db:migrate and generates mock AR Models'
        task migrate: [:'db:migrate'] do
          Moar::ModelBuilder.run
        end
      end
    end
  end
end
