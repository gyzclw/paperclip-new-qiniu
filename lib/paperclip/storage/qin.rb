module Paperclip
  module Storage
    module Qin
      def self.extended base
        begin
           require 'qiniu'
        rescue LoadError => e
          e.message << " (You may need to install the qiniu gem)#{Qiniu}"
          raise e
        end 

        base.instance_eval do
          unless @options[:url].to_s.match(/^:fog.*url$/)
            @options[:path]  = @options[:path].gsub(/:url/, @options[:url])
            @options[:url]   = ':qiniu_public_url'
          end
          Paperclip.interpolates(:qiniu_public_url) do |attachment, style|
            attachment.public_url(style)
          end unless Paperclip::Interpolations.respond_to? :qiniu_public_url
        end

      end

      def exists?(style = default_style)
        init
         !!Qiniu::Storage.stat(bucket,path(style))
      end

      def flush_writes
        init
        for style, file in @queued_for_write do
          retried = false
          begin
            upload(file, path(style))
          ensure
            file.rewind
          end
        end

        after_flush_writes # allows attachment to clean up temp files

        @queued_for_write = {}
      end

      def flush_deletes
        init
        for path in @queued_for_delete do
          Qiniu::Storage.delete(bucket, path)
        end
        @queued_for_delete = []
      end

      def public_url(style = default_style)
        init
          code, result, response_headers = Qiniu::Storage.stat(bucket, path(style))
          if code==200
            "#{@options[:qiniu_host]}/#{path(style)}"
          else
            nil
          end
      end

      private

      def init
        return if @inited
        Qiniu.establish_connection! access_key: @options[:qiniu_acess],
                             secret_key: @options[:qiniu_secret]
        inited = true
      end

      def upload(file, path)
        init
        put_policy = Qiniu::Auth::PutPolicy.new(
           bucket, # 存储空间
           path,    # 指定上传的资源名，如果传入 nil，就表示不指定资源名，将使用默认的资源名
           3600    # token 过期时间，默认为 3600 秒，即 1 小时
        )
        uptoken = Qiniu::Auth.generate_uptoken(put_policy)
        code, result, response_headers = Qiniu::Storage.upload_with_token_2(
            uptoken,
            file.path,
            path,
            nil,
            bucket: bucket
        )

        @public_url= "http://orh1veryp.bkt.clouddn.com/#{path}"
      end

      def bucket
          @options[:bucket]
      end

      def dynamic_fog_host_for_style(style)
        if @options[:qiniu_host].respond_to?(:call)
          @options[:qiniu_host].call(self)
        else
          @options[:qiniu_host]
        end
      end
    end
  end
end
