module Bookshare
  VERSION = File.file?(Rails.root.join('VERSION')) ? 
    File.read(Rails.root.join('VERSION')).strip.freeze : 'No VERSION'
  REVISION = File.file?(Rails.root.join('REVISION')) ?
  File.read(Rails.root.join('REVISION')).strip.first(7).freeze : 'No REVISION'
end
