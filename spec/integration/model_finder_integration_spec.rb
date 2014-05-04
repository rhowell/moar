require 'moar/model_finder'
require 'tempfile'

describe Moar::ModelFinder do
  context 'While running' do
    it 'Shall correctly find all models' do
      contents = <<-EOF
        class User <ActiveRecord::Base
        end
        class Admin < ActiveRecord::Base
        end
        #class OldUser<ActiveRecord::Base
        #end
        class SuperUser < User
        end
        class Utilities
        end
        class SuperUtils < Utilities
        end
      EOF

      file = Tempfile.new('simple_class.rb')
      file.write(contents)
      file.rewind

      expect(Dir).to receive(:entries).with('app/models') { ['models.rb'] }
      expect(File).to receive(:ftype).with(/app\/models\/.*\.rb/).at_least(:once) { "file" }
      expect(File).to receive(:open).with('app/models/models.rb', 'r') { file }

      mf = Moar::ModelFinder.run

      expect(mf.models).to eql 'User'      => 'app/models/models.rb',
                               'Admin'     => 'app/models/models.rb',
                               'SuperUser' => 'app/models/models.rb'

      file.close
      file.unlink
    end
  end
end
