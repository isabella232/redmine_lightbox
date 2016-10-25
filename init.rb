Redmine::Plugin.register :redmine_lightbox do
  name 'Redmine Lightbox plugin'
  author 'Restream'
  description 'Fancy gallery preview for attachments. Generate pdf preview for doc, docx, rtf.'
  version '2.0.0'
  url 'https://github.com/Restream/redmine_lightbox'

  requires_redmine version_or_higher: '2.6'
end

require 'redmine_lightbox'
