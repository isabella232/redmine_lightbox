module RedmineLightbox
  module Services
    class DocumentConverter
      # https://github.com/dagwieers/unoconv
      CONVERTER = 'unoconv'

      class << self
        def convert(filename, output_format)
          if filename.present? && File.exist?(filename)
            `#{converter_cmd} -f #{output_format} #{filename}`
          end
        end

        def preview_filename_for(filename, format)
          name, splitter, original_format = filename.rpartition('.')
          [name, splitter, format].join
        end

        def converter_available?
          `#{CONVERTER} --version`.present? rescue false
        end

        #
        # Returns convert command with options (if any)
        #
        # If additional options required then these options can be placed into
        # {REDMINE_ROOT}/config/additional_environment.rb
        #
        # For example:
        #
        # config.redmine_lightbox = {
        #   converter_options: '--server=127.0.0.1 --no-launch'
        # }
        #
        def converter_cmd
          if Rails.configuration.respond_to?(:redmine_lightbox) &&
            options = Rails.configuration.redmine_lightbox['converter_options']

            [CONVERTER, options].join(' ')
          else
            CONVERTER
          end
        end
      end
    end
  end
end
