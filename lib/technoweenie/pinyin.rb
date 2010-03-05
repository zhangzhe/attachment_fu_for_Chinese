require 'singleton'
class PinYin
  include Singleton
  def initialize
    require "yaml"
    @codes = YAML.load_file("#{File.dirname(__FILE__)}/Mandarin.yml")
  end

  def to_permlink(str)
    str_to_pinyin(str,'-')
  end
  
  def to_pinyin(str)
    str_to_pinyin(str, '')
  end
  
  private
  def get_value(code)
    @codes[code]
  end

  def str_to_pinyin(str, separator='')
    res = []
    str.to_s.unpack('U*').each_with_index do |t,idx|
      code = sprintf('%x',t).upcase
      val = get_value(code)
      if val
        val = val.gsub(/\d/,'')
        res << val.downcase+separator
      else
        tmp = [t].pack('U*')
        res << tmp if tmp =~ /^[_0-9a-zA-Z\s]*$/ 
      end
    end
    if separator==''
      return res.join(' ')
    else
      re = Regexp.new("\\#{separator}+")
      re2 = Regexp.new("\\#{separator}$")
      return res.join('').gsub(/\s+/,separator).gsub(re,separator).gsub(re2,'')
    end
  end
end
