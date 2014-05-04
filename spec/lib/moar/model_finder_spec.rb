require 'moar/model_finder'
require 'tempfile'

describe Moar::ModelFinder do
  context 'when searching for models' do
    it 'will find all files in the app/models directory' do
      expect(Dir).to receive(:entries).with('app/models') { ['user.rb', 'admin.rb', 'product.rb', 'concerns'] }
      expect(Dir).to receive(:entries).with('app/models/concerns') { ['concerning.rb'] }
      expect(File).to receive(:ftype).with(/app\/models\/.*\.rb/).at_least(:once) { "file" }
      expect(File).to receive(:ftype).with('app/models/concerns').at_least(:once) { "directory" }

      subject.get_files
      expect(subject.files).to eql ['app/models/user.rb', 'app/models/admin.rb', 'app/models/product.rb', 'app/models/concerns/concerning.rb'].to_set
    end

    it 'will find any classes that inherit directly from ActiveRecord::Base' do
      file_contents = <<-EOF
        class User < ActiveRecord::Base
        end
      EOF

      file = Tempfile.new('simple_class.rb')
      file.write(file_contents)
      file.close

      expect(subject).to receive(:files) { [file.path] }

      subject.get_models
      expect(subject.models).to eql  'User' => file.path

      file.unlink
    end

    it 'will find multiple models in the same file' do
      file_contents = <<-EOF
        class User < ActiveRecord::Base
        end
        # Funky...
        class Admin < ActiveRecord::Base
        end
      EOF

      file = Tempfile.new('multiple_classes.rb')
      file.write(file_contents)
      file.close

      expect(subject).to receive(:files) { [file.path] }

      subject.get_models
      expect(subject.models).to eql 'User' => file.path, 'Admin' => file.path


      file.unlink
    end

    it 'will not return models that are commented out' do
      file_contents = <<-EOF
        #class Defunctoid < ActiveRecord::Base
        #end
      EOF
      file = Tempfile.new('simple_class.rb')
      file.write(file_contents)
      file.close

      expect(subject).to receive(:files) { [file.path] }
      subject.get_models
      expect(subject.models).to eql({})

      file.unlink
    end

    it 'will return indirect subclasses of ActiveRecord::Base' do
      file_contents = <<-EOF
        class MommaBear< ActiveRecord::Base
        end

        class Kiddo < MommaBear
        end
      EOF

      file = Tempfile.new('inheritence.rb')
      file.write(file_contents)
      file.close

      expect(subject).to receive(:files) { [file.path] }
      subject.get_models
      expect(subject.models).to eql 'MommaBear' => file.path, 'Kiddo' => file.path

      file.unlink
    end

    it 'will return indirect subclasses of ActiveRecord::Base in seperate files' do
      contents_parent = <<-EOF
        class PoppaBear < ActiveRecord::Base
        end
      EOF
      contents_child = <<-EOF
        class Kiddo < PoppaBear
        end
      EOF


      file_parent = Tempfile.new('parent.rb')
      file_parent.write(contents_parent)
      file_parent.close

      file_child = Tempfile.new('parent.rb')
      file_child.write(contents_child)
      file_child.close

      expect(subject).to receive(:files) { [file_child.path, file_parent.path] }

      subject.get_models
      expect(subject.models).to eql 'PoppaBear' => file_parent.path, 'Kiddo' => file_child.path

      file_child.unlink
      file_parent.unlink
    end

    it 'will not return classes that are subclasses of non-Active Record models' do
      file_contents = <<-EOF
        class NopeATron < Tricksy
        end
      EOF

      file = Tempfile.new('tricksy.rb')
      file.write(file_contents)
      file.close

      expect(subject).to receive(:files) { [file.path] }

      subject.get_models

      expect(subject.models).to eql({})

      file.unlink
    end
  end
end
