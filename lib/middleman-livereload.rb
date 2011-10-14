require "middleman/guard"
require "guard/livereload"

Middleman::Guard.add_guard do |options, livereload|
  if livereload
    livereload_options_hash = ""
    
    livereload.each do |k,v|
      livereload_options_hash << ", :#{k} => "
      livereload_options_hash << ((v.kind_of?(String)) ? "'#{v}'" : "#{v.to_s}")
    end
    
    %Q{
      guard 'livereload'#{livereload_options_hash} do 
        watch(%r{^source/([^\.].*)$})
      end
    }
  else
    nil
  end
end