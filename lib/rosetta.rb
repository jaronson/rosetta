require 'active_record'
require 'i18n/backend/active_record'
require 'rosetta/version'
require 'rosetta/error'
require 'rosetta/concern'
require 'rosetta/phrase'
require 'rosetta/translation'

module Rosetta
end

ActiveRecord::Base.send(:include, Rosetta::Concern::ActiveRecordExtension)
