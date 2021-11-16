require "json"

module BingAdsRubySdk
  module OAuth2
    # Oauth2 token default non-encrypted File System store
    class FsStore
      S3_PATH = '2/bing_audience_credentials/auth_token.json'
      # @param filename [String] the uniq filename to identify filename storing data.
      def initialize(filename)
        @filename = filename
      end

      # Writes the token to file
      # @return [File] if the file was written (doesn't mean the token is).
      # @return [self] if the filename don't exist.
      def write(value)
        return nil unless filename
        file = File.open(filename, "w") { |f| JSON.dump(value, f) }
        S3Helper.new.upload_content(
          S3_PATH,
          file
        )
        self
      end

      # Reads the token from file
      # @return [Hash] if the token information that was stored.
      # @return [nil] if the file doesn't exist.
      def read
        s3_file = S3Helper.new.download(S3_PATH)
        JSON.parse(s3_file.body.read)
      end

      private

      attr_reader :filename
    end
  end
end
