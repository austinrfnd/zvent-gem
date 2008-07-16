# backported from rails
class Hash
  def to_query(namespace = nil)
    collect do |key, value|
      value.to_query(namespace ? "#{namespace}[#{key}]" : key)
    end.sort * '&'
  end
end

class Object
  def to_query(key)
    "#{CGI.escape(key.to_s)}=#{CGI.escape(to_param.to_s)}"
  end
  
  def to_param
    to_s
  end    
end