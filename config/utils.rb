module Utils
  class << self
    def load_files(files = [])
      Dir[*files].uniq.each do |filename|
        require API_ROOT.join(filename)
      end
    end
  end
end
