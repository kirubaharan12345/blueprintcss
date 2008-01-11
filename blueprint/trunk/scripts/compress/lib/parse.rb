class Parse
  
  # parses css file into compressed string of css
  def initialize(path)
    @css = ""
    
    data = path_to_string(path) # read the css file 
    data = strip_sidespace(data) # remove unwanted sidespace
    data = remove_css_space(data) # remove other whitespace
    
    # find selectors and properties
    data.split('}').each do |var|
      parts = var.split('{') 
      parts.map! { |p| p = strip_sidespace(p) }
      selector = parts[0]
      
      # find all properties for current selectors
      rules = ""
      parts[1].split(';').each do |str|
        split = str.split(':') # seperate properties and values
        break unless split[0] && split[1] # something's missing
        
        split.map! { |s| s = strip_sidespace(s) } # strip sidespace
        rules += split[0] + ':' + split[1] + '; ' # add rule to list
      end
      
      # remove bogus selector whitespace
      selector = remove_css_selector_space(selector)
      
      # add properly compressed css to the string
      @css += selector + ' { ' + rules + '}' + "\n"
    end
    @css
  end
  
  # return the css when Parse class is printed
  def to_s
    @css
  end
  
  # reads a file path into a string
  def path_to_string(path)
    File.new(path).read    
  end
  
  # removes unwanted space in css
  # keeps space inside properties
  def remove_css_space(data)
    data.gsub!(': ', ':') # remove unwanted spaces
    data.gsub!(/\n/, '') # remove newlines
    data.gsub!(/(\s\s)/, ' ') # remove multiple spaces
    data.gsub!(/(\/\*).*?(\*\/)/, '') # remove comments
    data
  end
  
  # removes unwanted whitespace in selector
  def remove_css_selector_space(selector)
    selector.gsub!(/(\n)/, '')
    selector.gsub!(',', ', ')
    selector.gsub!(',  ', ', ')
    selector
  end
  
  # strips all whitespace on both sides of a string
  def strip_sidespace(str)
    str.gsub!(/^\s+/, "")
    str.gsub!(/\s+$/, $/)
    str
  end
end
