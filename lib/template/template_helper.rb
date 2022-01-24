# typed: true
module Fly 
  module TemplateHelper
    def load_template
      template = <<~EOF
      {{title}}

      站点: {{site}}

      详情: {{url}}

      文件大小: {{size}}

      创建时间: {{date}}

      热度: {{hot}}

      {{summary}}
      EOF
    end
    # alias_method :template,:load_template
    def fill(obj)
      template = load_template
      if obj.is_a?(Hash)
        obj.each do | k,v |
          template = template.gsub("{{#{k}}}",v.to_s)
        end
      end
      template
    end
  end
end
