require 'byebug'
require 'set'
require 'tree'

module Moar
  class ModelFinder
    attr_accessor :files, :models

    ROOT_PATH = 'app/models'
    CLASS_REGEX = /^[^\#]+class\s*(?<class>\w*)\s*<\s*(?<parent>\w*(?:\w*|::)*)[\s\n\r$]/

    def self.run
      mf = ModelFinder.new
      mf.get_files
      mf.get_models

      mf
    end

    def get_files(curr_dir = ROOT_PATH)
      files_in_dir = []
      entries = Dir.entries(curr_dir).map { |e| File.join(curr_dir, e) }
      files_in_dir += entries.select { |e| File.ftype(e) == 'file' }
      entries.select { |e| File.ftype(e) == 'directory' }.each { |e| self.files += get_files(e) }

      self.files += files_in_dir
    end

    def get_models
      classes = []
      files.each do |f|
        classes += find_classes(f)
      end

      model_names = build_inheritence_tree(classes)

      classes.select { |cl| model_names.member? cl[:class_name] }.each { |cl| self.models.merge!(cl[:class_name] => cl[:file]) }
    end

    def find_classes(file_name)
      classes = []
      file = File.open(file_name, 'r')
      lines = file.readlines

      lines.each do |line|
        match = CLASS_REGEX.match(line)
        if match
          classes << {class_name: match[:class],
                      parent: match[:parent],
                      file: file_name}
        end
      end

      classes
    end

    def build_inheritence_tree(classes)
      root = Tree::TreeNode.new('ActiveRecord::Base')
      insertions_this_round = 0
      classes_tmp = classes.dup

      begin
        insertions_this_round = 0

        classes_tmp.each do |cl|
          node = root.detect { |n| n.name == cl[:parent] }
          if node
            node << Tree::TreeNode.new(cl[:class_name])
            insertions_this_round += 1
            classes_tmp.delete(cl)
          end
        end
      end while insertions_this_round > 0

      root.map { |n| n.name }
    end

    # You should only ever need to run the class method
    protected
    def initialize
      self.files = Set.new
      self.models = {}
    end
  end
end
