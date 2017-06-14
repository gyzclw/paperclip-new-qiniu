require "paperclip-qin/version"
require 'paperclip/storage/qin'
require 'paperclip/qin/action_view_extensions/qiniu_image_path' if defined?(ActionView)
require 'paperclip/qin/action_view_extensions/qiniu_image_tag' if defined?(ActionView)
