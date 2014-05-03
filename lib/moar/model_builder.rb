
module Moar
  class ModelBuilder
    def self.run
      puts "Models to be Mocked: "
      Dir.entries('app/models').each { |e| puts "\t#{e}" }
    end
  end
end
